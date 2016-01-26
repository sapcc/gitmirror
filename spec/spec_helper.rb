$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gitmirror'

RSpec.configure do |config|
  require_relative 'support/git_helpers'
  config.include(Gitmirror::RSpec::GitHelpers)
  require_relative 'support/path_helpers'
  config.include(Gitmirror::RSpec::PathHelpers)

  require_relative 'backend_spec'

  config.before(:each) do
    clean_tmp_path
  end
end
