require 'tempfile'
require 'shellwords'
require 'fileutils'
module Gitmirror
  module Backend
    class Base

      def mirror url, local_repo_path, credential=nil

        #init bare repository
        unless File.exists? local_repo_path 
          FileUtils.mkdir_p local_repo_path
          git({}, "init", "--bare", local_repo_path) #idempotent, does not harm existing repos
          git({}, "--git-dir", local_repo_path, "remote", "add", "origin", "--mirror=fetch", url) #raises an error
        end
        #fetch updates
        if credential
          case url
          when /^https:\/\//
            u = URI.parse(url)
            if u.user
              u.password = credential
            else
              u.user = credential
            end
            git({}, "--git-dir", local_repo_path, "remote", "set-url", "origin", u.to_s)
            git({"GIT_ASKPASS"=> "/bin/echo"}, "--git-dir" ,local_repo_path, "fetch", "origin")
          else
            #assuming ssh protocol
            Tempfile.open("ssh-key") do |file|
              file.write(credential)
              file.close
              git({"GIT_SSH_COMMAND"=> "ssh -o BatchMode=yes -i #{file.path}"}, "--git-dir" ,local_repo_path, "fetch", "origin")
            end
          end
        else
          # no auth, no problems
          git({}, "--git-dir" ,local_repo_path, "fetch", "origin")
        end
        local_repo_path
      end

      def checkout repo_path, workdir, rev
        #checkout workdir
        FileUtils.mkdir_p workdir
        git({}, "--git-dir", repo_path, "--work-tree", workdir, "checkout", "-f", rev)
        git({}, "--git-dir", repo_path, "rev-parse", rev).rstrip
      end

    end
  end
end
