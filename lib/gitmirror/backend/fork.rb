require 'gitmirror/backend/base'
require 'open3'
module Gitmirror
  module Backend
    class Fork <Base
      include Gitmirror::Log

      private

      def git env, *args
        command = ['git'].concat args
        log.debug %{Executing #{env.map{|k,v| "#{k}=#{v}"}.join(" ")} #{command}}
        out, status = Open3.capture2e(env, "git", *args)
        raise GitError, "Executing [#{command}] failed: #{out}" if status.exitstatus != 0
        out
      end

    end
  end
end
