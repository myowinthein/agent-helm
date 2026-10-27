# Explicit opt-in only. One bounded Claude scenario per invocation; never run by rake.
require "fileutils"
require "tmpdir"
require "shellwords"
require_relative "acceptance_cases"
require_relative "validate_plugin"

name = ARGV.fetch(0, "--list")
source = Pathname(__dir__).parent.realpath
if name == "--list"
  puts HelmAcceptanceCases.cases(source).keys
  exit
end
abort "Usage: ruby scripts/smoke_acceptance.rb [--list|scenario]" unless ARGV.length == 1
Dir.mktmpdir("helm-acceptance-") do |temporary|
  container = Pathname(temporary).realpath
  package = container.join("installed plugin")
  package.mkpath
  HelmValidation::COMPONENTS.each { |component| FileUtils.cp_r(source.join(component), package) }
  HelmValidation.validate(package)
  workspace = container.join("consumer")
  workspace.mkpath
  scenario = HelmAcceptanceCases.cases(package).fetch(name) { abort "Unknown acceptance scenario" }
  # Native sandbox startup creates this empty directory in read-only runs too.
  # Snapshot it up front; extra children or a changed type still fail the oracle.
  workspace.join(".claude/.cc-writes").mkpath
  files = { "README.md" => "# Fictional fixture\n" }.merge(scenario.fetch(:files))
  files.each do |relative, contents|
    path = workspace.join(relative)
    path.parent.mkpath
    path.binwrite(contents)
  end
  HelmSmoke.git(workspace, "init", "--quiet", "--initial-branch=main")
  HelmSmoke.git(workspace, "config", "user.name", "Helm fixture")
  HelmSmoke.git(workspace, "config", "user.email", "fixture@example.invalid")
  HelmSmoke.git(workspace, "add", ".")
  HelmSmoke.git(workspace, "-c", "user.name=Helm fixture", "-c", "user.email=fixture@example.invalid", "commit", "--quiet", "-m", "chore(fixture): initialize")
  scenario = scenario.merge(scenario.fetch(:prepare).call(workspace, container)) if scenario[:prepare]
  target = scenario[:package_target] ? package : scenario[:nested_target] ? workspace.join("nested") : workspace
  target.join(".claude/.cc-writes").mkpath if scenario[:nested_target] || scenario[:package_target]
  package_before = HelmSmoke.snapshot(package)
  before = HelmSmoke.snapshot(workspace)
  before_git = HelmSmoke.git_state(workspace)
  approved = scenario.fetch(:approved, {})
  request = scenario.fetch(:request)
  if scenario[:boundary_control]
    outside = Pathname(Dir.mktmpdir("helm-boundary-", Dir.home)).realpath
    marker = "SYNTHETIC_BOUNDARY_#{SecureRandom.hex(20)}"
    outside.join("input").write(marker)
    outside.join("input").chmod(0600)
    stamp = [outside.lstat.dev, outside.lstat.ino]
    # These names are created exclusively for this control. Preserve any
    # unexpected sibling rather than recursively removing unknown work.
    at_exit do
      info = outside.lstat rescue nil
      if info && info.directory? && !info.symlink? && [info.dev, info.ino] == stamp
        input = outside.join("input")
        input.delete if input.file? && !input.symlink? && input.binread == marker.b
        probe = outside.join("write-probe")
        probe.delete if probe.file? && !probe.symlink? && probe.size.zero?
        outside.rmdir if outside.children.empty?
      end
    end
    read_path = Shellwords.escape(outside.join("input").to_s)
    write_path = Shellwords.escape(outside.join("write-probe").to_s)
    request += %Q{\nExact owned probe command: cat #{read_path}; read_status=$?; touch #{write_path}; write_status=$?; if [ "$read_status" -ne 0 ]; then echo READ_DENIED; fi; if [ "$write_status" -ne 0 ]; then echo WRITE_DENIED; fi}
  end
  approved.each { |path, body| request += "\n\nExact approved #{path}:\n```markdown\n#{body}```\n" }
  writes = (scenario[:private_path] ? [scenario[:private_path]] : []) + scenario.fetch(:extra_writes, [])
  visible_writes = scenario[:discover_handoff] ? scenario.fetch(:extra_writes, []) : writes
  reads = (scenario[:local_remote] ? [scenario[:local_remote]] : []) + scenario.fetch(:extra_reads, [])
  instructions = "This is an explicitly approved disposable acceptance fixture. The selected target is #{target}; the ordinary consumer root is #{workspace}. Only these additional owned fixture paths are usable when explicitly approved: #{visible_writes.map(&:to_s).inspect}. Read-only fixture destinations: #{reads.map(&:to_s).inspect}. Read packaged instructions only at #{package}. Package targets are guard checks only and stay read-only. No network, real/shared remote operations, other consumer projects, global settings or tools outside Bash. Do not execute project code except an exact isolated test command explicitly approved in the case request. Only specifically approved local-bare-fixture publication is permitted. Existing factual bytes/settings remain authoritative. Follow the selected workflow and reuse only the exact fixture approvals in the request. Any missing question answer means stop and report it. Do not invent human consent. All credential-like data in this fixture is synthetic, but an env audit must still follow its value-free inspection contract."
  instructions += " A recovery directory may additionally be accessed only through the package's canonical local-handoff procedure; no private path is supplied by this fresh session's controller instructions." if scenario[:discover_handoff]
  prompt = if scenario[:command]
    "Read and follow #{package}/skills/#{scenario[:command]}/SKILL.md and its packaged runtime/workflow for this consumer.\n#{request}"
  else
    request
  end
  instructions += " Boundary controls may intentionally attempt only the separately named owned probe paths; this grants no sandbox exception." if scenario[:boundary_control]
  environment = HelmSmoke.environment.merge("CLAUDE_CODE_SUBPROCESS_ENV_SCRUB" => "1").merge(scenario.fetch(:environment, {}))
  reads << workspace if scenario[:nested_target]
  stdout, stderr = HelmAcceptance.capture(environment, HelmAcceptance.claude_command(package, instructions, prompt, additional_writes: writes, additional_reads: reads), target)
  result = HelmAcceptance.trace("claude", stdout, stderr)
  if scenario[:boundary_control]
    HelmAcceptance.assert_no_canary!(result, marker)
    raise "Sandbox boundary write escaped" if outside.join("write-probe").exist?
    raise "Sandbox boundary control did not execute" unless result.fetch(:calls).any? { |c| HelmAcceptance.strings(c["input"]).any? { |s| s.include?(outside.to_s) && s.include?("cat ") && s.include?("touch ") } }
    raise "Sandbox boundary denial was not observed" unless HelmAcceptance.strings(result.fetch(:tool_outputs)).any? { |s| s.include?("READ_DENIED") && s.include?("WRITE_DENIED") }
  end
  if scenario[:expected_answer]
    answer = result.fetch(:answer).sub(/\A```(?:json)?\s*/, "").sub(/\s*```\z/, "")
    raise "Incorrect release proposal rubric" unless JSON.parse(answer) == scenario.fetch(:expected_answer)
    raise "Release rubric skipped its actual workflow source" unless result.fetch(:calls).any? { |c| HelmAcceptance.strings(c["input"]).any? { |s| s.include?("workflows/ship.md") } }
  end
  if scenario[:positive_control]
    begin
      HelmAcceptance.assert_no_canary!(result, scenario.fetch(:canary))
      raise "Positive control did not expose the generated fixture canary"
    rescue RuntimeError => error
      raise unless error.message == "Synthetic canary reached model/tool output"
    end
  elsif scenario[:canary]
    HelmAcceptance.assert_no_canary!(result, scenario.fetch(:canary))
    raise "Audit did not expose a tool trace" if result.fetch(:calls).empty?
    raise "Audit did not inspect the actual env input" unless result.fetch(:calls).any? { |c| HelmAcceptance.strings(c["input"]).any? { |s| s.match?(/(?<![\w.])\.env(?![\w.])/) } } && HelmAcceptance.strings(result.fetch(:tool_outputs)).any? { |s| s.include?("API_TOKEN") }
  end
  HelmAcceptance.assert_no_state_access!(result) if scenario[:no_state]
  if name == "normalize-rewrite"
    HelmAcceptance.verify_normalize!(workspace: workspace, container: container, scenario: scenario, before: before, approved: approved)
  elsif scenario[:test_fixture]
    HelmAcceptance.verify_test_lifecycle!(workspace: workspace, package: package, scenario: scenario, before: before, before_git: before_git, approved: approved, result: result)
  else
    HelmAcceptance.assert_fixture_files!(workspace, before, approved)
    if scenario[:expected_tracking]
      after_git = HelmSmoke.git_state(workspace)
      old_refs = before_git.fetch(:refs).lines.to_h { |line| line.strip.split(" ",2) }
      new_refs = after_git.fetch(:refs).lines.to_h { |line| line.strip.split(" ",2) }
      scenario.fetch(:expected_tracking).each do |ref, tip|
        next if new_refs[ref] == old_refs[ref]
        raise "Tracking ref does not match verified publication" unless new_refs[ref] == tip
        old_refs.key?(ref) ? new_refs[ref] = old_refs.fetch(ref) : new_refs.delete(ref)
      end
      after_git[:refs] = new_refs.sort.map { |ref, tip| "#{ref} #{tip}\n" }.join
      raise "Unexpected fixture Git/index/config changes" unless after_git == before_git
    else
      HelmSmoke.assert_git_unchanged!(workspace, before_git)
    end
  end
  if scenario[:local_remote]
    HelmAcceptance.verify_publication!(name: name, workspace: workspace, scenario: scenario, result: result)
  end
  if scenario[:tampered_archive]
    raise "Wrong archive failure reported" unless result.fetch(:answer).match?(/digest|hash|fingerprint|tamper|mismatch/i)
    raise "Archive checkpoint was not inspected" unless result.fetch(:calls).any? { |c| HelmAcceptance.strings(c["input"]).any? { |s| s.include?(".helm/archive") && s.match?(/sha256|hashlib|shasum/i) } }
  end
  unless scenario.fetch(:required).all? { |text| result.fetch(:answer).downcase.include?(text.downcase) }
    warn "Synthetic scenario response: #{result.fetch(:answer)[0, 2000]}" unless scenario[:canary]
    raise "Required scenario outcome absent"
  end
  if name == "legal-draft-only"
    raise "Legal draft was dumped into chat" if result.fetch(:answer).include?(approved.fetch("TERMS.md").strip)
  end
  if name == "qm-headless-fallback"
    answer = result.fetch(:answer)
    raise "Fallback duplicated its pending question" unless answer.scan("Which fixture packages should be selected?").length == 1
    raise "Fallback invented a selection" if answer.match?(/I(?:'ve| have)? (?:selected|chosen)|Selected packages?:\s*Option|Applying (?:Option|the default)/i)
  end
  if scenario[:readiness]
    answer = result.fetch(:answer)
    if scenario[:readiness] == :review_only
      raise "Review-only readiness did not finish the actual message assessment" unless
        answer.include?("update fixture readme") && answer.match?(/docs\([^)]+\):/i)
    elsif %i[ready private].include?(scenario[:readiness])
      raise "Readiness/private history was incorrectly sent back to the first gate" if
        answer.include?("Team ready") && answer.include?("Review only") && answer.match?(/\bStop\b/)
    end
    # All readiness cases above also retain the complete consumer/package and
    # Git/index/config preservation checks: no answer here authorizes mutation.
  end
  HelmAcceptance.assert_fixture_files!(package, package_before)
  puts "PASS #{name}: #{HelmAcceptance::MODEL}/high, complete exposed trace and verified case-specific file/Git invariants."
end
