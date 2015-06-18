$LOAD_PATH.unshift(File.join(__FILE__, "..", "..", "lib"))

require 'wcc/auth'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
