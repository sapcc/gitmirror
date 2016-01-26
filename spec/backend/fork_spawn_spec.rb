require 'spec_helper'
require 'gitmirror/backend/fork'

describe Gitmirror::Backend::Fork do
  before(:all) do
    Gitmirror.backend = :fork
  end
  it_behaves_like "backend"
end 
