$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gitmirror'
require 'logger'

RSpec.configure do |config|
  require_relative 'support/git_helpers'
  config.include(Gitmirror::RSpec::GitHelpers)
  require_relative 'support/path_helpers'
  config.include(Gitmirror::RSpec::PathHelpers)

  require_relative 'backend_spec'

  Gitmirror.logger = Logger.new(STDOUT)

  config.before(:each) do
    clean_tmp_path
  end
end
