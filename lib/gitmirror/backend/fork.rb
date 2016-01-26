module Gitmirror
  module Backend
    class Fork
      include Gitmirror::Log

      def mirror url, local_repo_path
        #init bare repository
        unless File.exists? local_repo_path 
          FileUtils.mkdir_p local_repo_path
          in_path local_repo_path do
            git "init --bare" #idempotent, does not harm existing repos
            git "remote add origin --mirror=fetch #{url}" #raises an error
          end
        end
        #fetch updates
        in_path local_repo_path do
          git "fetch origin"
        end
        local_repo_path
      end

      def checkout repo_path, workdir, rev
        #checkout workdir
        FileUtils.mkdir_p workdir 
        in_path repo_path do
          git "--work-tree #{workdir} checkout -f #{rev}"
          git("rev-parse #{rev}").rstrip
        end
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

      def in_path path, &block
        Dir.chdir(path, &block)
      end

    end
  end
end
