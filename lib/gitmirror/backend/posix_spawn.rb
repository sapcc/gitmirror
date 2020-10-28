require 'gitmirror/backend/base'
require 'posix-spawn'
module Gitmirror
  module Backend
    class PosixSpawn < Base
      include Gitmirror::Log
      private

      def git env, *args
        command = ['git'].concat args
        log.debug %{Executing #{env.map{|k,v| "#{k}=#{v}"}.join(" ")} #{command}}
        child = POSIX::Spawn::Child.new(env, "git", *args)
        raise GitError, "Executing [#{command.join(' ')}] failed: #{child.err} #{child.out}" if child.status.exitstatus != 0
        child.err+child.out
      end
    end
  end
end
