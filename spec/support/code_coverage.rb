require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/bin'
  add_filter '/db'
  add_filter '/spec'

  add_group 'System', 'spec/system'

  enable_coverage :branch
end
