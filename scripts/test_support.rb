# Small assertions shared by the offline Ruby suites. They call no models.
def expect(condition)
  raise "Offline check failed" unless condition
end

# Returns the RuntimeError a guard raises; fails when the guard accepts the input.
def rejects
  yield
rescue RuntimeError => error
  error
else
  raise "Expected the guard to reject this input"
end

def rejects_with(message, &block)
  expect(rejects(&block).message == message)
end
