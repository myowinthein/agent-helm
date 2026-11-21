require 'cgi'
require 'digest'
require 'fileutils'
require 'json'
require 'open3'
require 'rexml/document'

module HelmFrontend
  DIAGRAM = %r{<pre><code class="language-mermaid">(.*?)</code></pre>}m

  def self.replace_once(source, before, after)
    unless source.scan(Regexp.new(Regexp.escape(before))).size == 1
      raise ArgumentError, "Just the Docs theme changed: expected one #{before.strip.inspect}"
    end
    source.sub(before, after)
  end

  def self.initial_theme(html, base)
    default = "#{base}/assets/css/just-the-docs-default.css"
    link = %(<link rel="stylesheet" href="#{default}">)
    return html unless html.include?(link)

    replace_once(html, link, <<~HTML)
      <script>
        (() => {
          const light = #{JSON.generate("#{base}/assets/css/just-the-docs-light.css")};
          const dark = #{JSON.generate("#{base}/assets/css/just-the-docs-dark.css")};
          let mode = 'system';
          try {
            const saved = localStorage.getItem('agent-helm-theme');
            if (['system', 'light', 'dark'].includes(saved)) mode = saved;
          } catch {}
          const theme = mode === 'system' ? (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light') : mode;
          const stylesheet = document.createElement('link');
          stylesheet.id = 'helm-theme-stylesheet';
          stylesheet.rel = 'stylesheet';
          stylesheet.setAttribute('blocking', 'render');
          stylesheet.href = theme === 'dark' ? dark : light;
          stylesheet.addEventListener('error', () => {
            stylesheet.dataset.themeLoadFailed = 'true';
            if (stylesheet.href !== new URL(light, document.baseURI).href) {
              stylesheet.href = light;
              document.documentElement.style.colorScheme = 'light';
            }
          });
          document.head.append(stylesheet);
          document.documentElement.style.colorScheme = theme;
        })();
      </script>
      <noscript><link rel="stylesheet" href="#{default}"></noscript>
    HTML
  end

  def self.lazy_search(source)
    source = replace_once(source, 'function initSearch() {', <<~JS.chomp)
      let helmSearchStarted = false;
      let helmSearchFailedState = false;
      let helmSearchPendingTimer;
      let helmSearchErrorTimer;
      let helmSearchInput;
      let helmSearchStatus;
      let helmSearchRetry;
      function clearHelmSearchFeedback() {
        clearTimeout(helmSearchPendingTimer);
        clearTimeout(helmSearchErrorTimer);
        helmSearchStatus.textContent = '';
      }
      function helmSearchFailed() {
        clearHelmSearchFeedback();
        helmSearchFailedState = true;
        helmSearchInput.removeAttribute('aria-busy');
        helmSearchRetry.hidden = false;
        helmSearchRetry.disabled = false;
        helmSearchStatus.textContent = 'Could not load search. Use Retry search to try again.';
        helmSearchErrorTimer = setTimeout(() => { helmSearchStatus.textContent = ''; }, 4000);
      }
      function initSearch() {
        if (helmSearchStarted) return;
        helmSearchStarted = true;
        helmSearchFailedState = false;
        clearHelmSearchFeedback();
        helmSearchRetry.disabled = true;
        helmSearchInput.setAttribute('aria-busy', 'true');
        helmSearchPendingTimer = setTimeout(() => { helmSearchStatus.textContent = 'Loading search…'; }, 200);
    JS
    source = replace_once(source, '      var docs = JSON.parse(request.responseText);',
      "      try {\n      var docs = JSON.parse(request.responseText);")
    source = replace_once(source, '      searchLoaded(index, docs);', <<~JS.chomp)
            searchLoaded(index, docs);
            clearHelmSearchFeedback();
            helmSearchRetry.hidden = true;
            helmSearchInput.removeAttribute('aria-busy');
            const input = document.getElementById('search-input');
            if (document.activeElement === input) input.dispatchEvent(new Event("focus"));
            } catch {
              helmSearchStarted = false;
              helmSearchFailed();
            }
    JS
    source = replace_once(source,
      "      console.log('Error loading ajax request. Request status:' + request.status);",
      "      helmSearchStarted = false;\n      helmSearchFailed();\n      console.log('Error loading ajax request. Request status:' + request.status);")
    source = replace_once(source,
      "    console.log('There was a connection error');",
      "    helmSearchStarted = false;\n    helmSearchFailed();\n    console.log('There was a connection error');")
    source = replace_once(source, "  jtd.addEvent(searchInput, 'focus', function(){",
      "  searchInput.addEventListener('input', update);\n\n  jtd.addEvent(searchInput, 'focus', function(){")
    source = replace_once(source, '    const nextFocusedElement = evt.relatedTarget;',
      "    const nextFocusedElement = evt.relatedTarget;\n    if (!nextFocusedElement) { hideSearch(); return; }")
    shortcut = source.match(%r{  // add event listener on ctrl[^\n]*\n  jtd\.addEvent\(document, 'keydown',[\s\S]*?\n  \}\);})
    source = source.sub(shortcut[0], '') if shortcut
    source = replace_once(source, '  initSearch();', <<~JS.chomp)
        const searchInput = document.getElementById('search-input');
        if (searchInput) {
          helmSearchInput = searchInput;
          helmSearchStatus = document.getElementById('search-status');
          helmSearchRetry = document.getElementById('search-retry');
          searchInput.addEventListener("focus", initSearch);
          searchInput.addEventListener("input", () => { if (!helmSearchFailedState) initSearch(); });
          helmSearchRetry.addEventListener("click", () => {
            initSearch();
            searchInput.focus();
          });
          const mainHeader = document.getElementById('main-header');
          #{shortcut && shortcut[0]}
          if (document.activeElement === searchInput || searchInput.value) initSearch();
        }
    JS
    source
  end

  def self.clipboard_feedback(source)
    source = replace_once(source, '  codeBlocks.forEach(codeBlock => {',
      "  let clearCopyConfirmation = null;\n  let clearCopyFailure = null;\n  codeBlocks.forEach(codeBlock => {")
    source = replace_once(source, "    copyButton.addEventListener('click', function () {", <<~JS.chomp)
          const feedback = document.createElement('span');
          feedback.className = 'interaction-feedback copy-status';
          feedback.setAttribute('role', 'status');
          codeBlock.append(feedback);
          let copying = false;
          const resetConfirmation = () => {
            clearTimeout(timeout);
            timeout = null;
            copyButton.innerHTML = svgCopy;
            feedback.textContent = '';
            if (clearCopyConfirmation === resetConfirmation) clearCopyConfirmation = null;
            if (clearCopyFailure === resetConfirmation) clearCopyFailure = null;
          };
          copyButton.addEventListener('click', async function () {
    JS
    source = replace_once(source, '      if(timeout === null) {', <<~JS.chomp)
            if (!copying) {
              if (clearCopyFailure) clearCopyFailure();
              clearTimeout(timeout);
              if (clearCopyConfirmation === resetConfirmation) clearCopyConfirmation = null;
              copying = true;
              copyButton.setAttribute('aria-busy', 'true');
              copyButton.setAttribute('aria-disabled', 'true');
              const pendingFeedback = setTimeout(() => {
                copyButton.innerHTML = svgCopy;
                feedback.textContent = 'Copying…';
              }, 200);
              try {
    JS
    source = replace_once(source, '        window.navigator.clipboard.writeText(code);',
      '        await window.navigator.clipboard.writeText(code);')
    source = replace_once(source, '        copyButton.innerHTML = svgCopied;', <<~JS.chomp)
            if (clearCopyConfirmation) clearCopyConfirmation();
            if (clearCopyFailure) clearCopyFailure();
            clearCopyConfirmation = resetConfirmation;
            copyButton.innerHTML = svgCopied;
            feedback.textContent = 'Copied';
    JS
    source = replace_once(source, '        var timeoutSetting = 4000;', '        var timeoutSetting = 2000;')
    replace_once(source, "        timeout = setTimeout(function () {\n          copyButton.innerHTML = svgCopy;\n          timeout = null;\n        }, timeoutSetting);", <<~JS.chomp)
              timeout = setTimeout(resetConfirmation, timeoutSetting);
              } catch {
                if (clearCopyFailure) clearCopyFailure();
                clearCopyFailure = resetConfirmation;
                copyButton.innerHTML = svgCopy;
                feedback.textContent = 'Could not copy. Try again or select the code to copy it manually.';
                timeout = setTimeout(resetConfirmation, 4000);
              } finally {
                clearTimeout(pendingFeedback);
                copying = false;
                copyButton.removeAttribute('aria-busy');
                copyButton.removeAttribute('aria-disabled');
              }
    JS
  end

  def self.dimensions(svg)
    view_box = REXML::Document.new(svg).root.attributes['viewBox'].to_s.split.map { |number| Float(number) }
    unless view_box.size == 4 && view_box.all?(&:finite?) && view_box[2..].all?(&:positive?)
      raise ArgumentError, 'Invalid Mermaid diagram dimensions'
    end
    view_box[2..]
  end

  def self.optimize(site)
    pages = site.pages.select { |page| page.output_ext == '.html' }
    worker = File.join(site.source, 'scripts/render-diagrams.mjs')
    renderer = File.read(worker) + File.read(File.join(site.source, 'package-lock.json'))
    diagrams = {}
    pages.each do |page|
      page.output.scan(DIAGRAM).each do |match|
        source = CGI.unescapeHTML(match.first)
        id = Digest::SHA256.hexdigest(renderer + source)
        diagrams[id] = source
      end
    end
    cache = File.join(site.source, '.jekyll-cache/mermaid/assets/diagrams')
    FileUtils.mkdir_p(cache) unless diagrams.empty?
    missing = diagrams.reject { |id, _| File.file?(File.join(cache, "#{id}.svg")) }
    unless missing.empty?
      output, error, status = Open3.capture3('node', worker, stdin_data: JSON.generate(missing))
      raise "Diagram rendering failed: #{error}" unless status.success?
      rendered = JSON.parse(output)
      raise 'Incomplete Mermaid render result' unless rendered.keys.sort == missing.keys.sort
      rendered.each do |id, svg|
        dimensions(svg)
        File.write(File.join(cache, "#{id}.svg"), svg)
      end
    end
    diagrams.each_key do |id|
      site.static_files << Jekyll::StaticFile.new(site, File.join(site.source, '.jekyll-cache/mermaid'), '/assets/diagrams', "#{id}.svg")
    end
    pages.each do |page|
      html = initial_theme(page.output, site.baseurl.to_s)
      if html.include?('id="search-input"')
        html = replace_once(html, '<div id="search-results" class="search-results"></div>',
          '<p id="search-status" class="interaction-feedback search-status" role="status"></p><div id="search-results" class="search-results"></div>')
        html = replace_once(html, 'id="search-input"', 'id="search-input" aria-describedby="search-status"')
        label = html.match(%r{<label for="search-input" class="search-label">.*?</label>}m)&.to_s
        raise ArgumentError, 'Just the Docs theme changed: missing search label' unless label
        html = replace_once(html, label,
          label + '<button id="search-retry" class="search-retry" type="button" aria-label="Search unavailable. Retry search." title="Search unavailable" hidden>Retry search</button>')
      end
      page.output = html.gsub(DIAGRAM) do
        source = CGI.unescapeHTML(Regexp.last_match(1))
        id = Digest::SHA256.hexdigest(renderer + source)
        width, height = dimensions(File.read(File.join(cache, "#{id}.svg")))
        label = CGI.escapeHTML("Workflow diagram for #{page.data['title']}")
        %(<figure class="mermaid"><img src="#{site.baseurl}/assets/diagrams/#{id}.svg" width="#{width.ceil}" height="#{height.ceil}" style="aspect-ratio: #{width} / #{height};" alt="#{label}" decoding="async"></figure>)
      end
    end
    site.pages.select { |page| page.url == '/assets/js/just-the-docs.js' }.each do |page|
      page.output = lazy_search(page.output) unless site.config['search_enabled'] == false
      page.output = clipboard_feedback(page.output) unless site.config['enable_copy_code_button'] == false
    end
  end
end

Jekyll::Hooks.register :site, :post_render do |site|
  HelmFrontend.optimize(site)
end
