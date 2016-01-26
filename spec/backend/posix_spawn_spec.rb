require 'spec_helper'
require 'gitmirror/backend/posix_spawn'

describe Gitmirror::Backend::PosixSpawn do

  before(:all) do
    Gitmirror.backend = :posix_spawn
  end

  it_behaves_like "backend"
end
