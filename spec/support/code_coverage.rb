require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.single_report_path = 'coverage/lcov.info'
end

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter
]

SimpleCov.start 'rails' do
  add_filter '/bin'
  add_filter '/db'
  add_filter '/spec'
  add_filter '/spec/fixtures'

  add_group 'System', 'spec/system'

  enable_coverage :branch
end
