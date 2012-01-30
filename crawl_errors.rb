require 'uri'

require File.join(File.dirname(__FILE__), 'lib', 'crawl_errors.rb')

uri = URI.parse(ARGV[0]) if ARGV[0]
invalid_args = !uri.is_a?(URI::HTTP)

if invalid_args || ARGV.include?('--help') || ARGV.include?('-h')
  $stderr.puts("Error: URL must be a fully qualified HTTP URL (including protocol).") if invalid_args
  $stderr.puts("Usage: #{$0} <url> [-h|--help] [--report-errors-only] [--log FILE [--only-log-errors]]")
  exit 127
end

app = CrawlErrors.new(uri)
app.report_errors_only = ARGV.include?('--report-errors-only')
if ARGV.include?('--log')
  file = ARGV[ARGV.index('--log')+1]
  if file
    app.only_log_errors = ARGV.include?('--only-log-errors')
    system "touch #{file}"
    app.log = file
  end
end
app.run
