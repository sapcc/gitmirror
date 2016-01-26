require 'gitmirror/backend/fork'
require 'posix-spawn'
module Gitmirror
  module Backend
    class PosixSpawn <Fork 
      #POSIX::Spawns overrides `` from Kernel
      include POSIX::Spawn
    end
  end
end
