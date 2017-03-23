error = false

loop do
  error ? STDERR.puts('Error') : puts('ok')
  error = !error
  sleep 1
end
