module Gitmirror
  module Backend
    class Fork
      include Gitmirror::Log

      def mirror url, local_repo_path
        #init bare repository
        unless File.exists? local_repo_path 
          FileUtils.mkdir_p local_repo_path
          git "init --bare #{local_repo_path}" #idempotent, does not harm existing repos
          git "--git-dir=#{local_repo_path} remote add origin --mirror=fetch #{url}" #raises an error
        end
        #fetch updates
        git "--git-dir=#{local_repo_path} fetch origin"
        local_repo_path
      end

      def checkout repo_path, workdir, rev
        #checkout workdir
        FileUtils.mkdir_p workdir
        git "--git-dir=#{repo_path} --work-tree #{workdir} checkout -f #{rev}"
        git("--git-dir=#{repo_path} rev-parse #{rev}").rstrip
      end

      private

      def git command 
        command= "git #{command}"
        log.debug "Executing #{command}"
        #return true
        out = `#{command} 2>&1`
        raise GitError, "Executing [#{command}] failed: #{out}" if $?.exitstatus != 0
        out
      end

    end
  end
end
