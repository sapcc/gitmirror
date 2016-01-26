module Gitmirror 
  module RSpec
    module GitHelpers

      def local_git_repo(name, options={})
        path = git_scratch
        Dir.chdir(path) do
          # Create a bogus configure file
          File.open('configure', 'w') { |f| f.write('echo "Done!"') }

          git %|init .|
          git %|add .|
          git %|commit -am "Initial commit for #{name}..."|
          git %|remote add origin "#{options[:remote]}"| if options[:remote]
          git %|push origin master| if options[:remote]

          options[:annotated_tags].each do |tag|
            File.open('tag', 'w') { |f| f.write(tag) }
            git %|add tag|
            git %|commit -am "Create tag #{tag}"|
            git %|tag "#{tag}" -m "#{tag}"|
            git %|push origin "#{tag}"| if options[:remote]
          end if options[:annotated_tags]

          options[:tags].each do |tag|
            File.open('tag', 'w') { |f| f.write(tag) }
            git %|add tag|
            git %|commit -am "Create tag #{tag}"|
            git %|tag "#{tag}"|
            git %|push origin "#{tag}"| if options[:remote]
          end if options[:tags]

          options[:branches].each do |branch|
            git %|checkout -b #{branch} master|
            File.open('branch', 'w') { |f| f.write(branch) }
            git %|add branch|
            git %|commit -am "Create branch #{branch}"|
            git %|push origin "#{branch}"| if options[:remote]
            git %|checkout master|
          end if options[:branches]
        end
        path
      end

      def add_commit(file, content, message, options={} )
        Dir.chdir(git_scratch) do
          File.open(file, 'w') { |f| f.write(content) }
          git %|add #{file}|
          git %|commit -am "#{message}"|
          git %|push origin HEAD| if options[:remote]
        end
      end

      def remote_git_repo(name, options = {})
        path = File.join(remotes, name)
        remote_url = "file://#{path}"
        options[:remote] = remote_url
        # Create a bogus software
        FileUtils.mkdir_p(path)

        Dir.chdir(path) do
          git %|init --bare|
          git %|config core.sharedrepository 1|
          git %|config receive.denyNonFastforwards true|
          git %|config receive.denyCurrentBranch ignore|
        end

        local_git_repo(name, options)
        path
      end

      # Calculate the git sha for the given ref.
      #
      # @param [#to_s] repo
      #   the repository to show the ref for
      # @param [#to_s] ref
      #   the ref to show
      #
      # @return [String]
      def sha_for_ref(repo, ref)
        Dir.chdir(File.join(remotes, repo)) do
          git("show-ref #{ref}").stdout.split(/\s/).first
        end
      end

      private

      # The path to store the git remotes.
      #
      # @return [Pathname]
      def remotes
        path = File.join(tmp_path, 'git', 'remotes')
        FileUtils.mkdir_p(path) unless File.directory?(path)
        path
      end

      def git_scratch
        path = File.join(tmp_path, 'git', 'scratch')
        FileUtils.mkdir_p(path) unless File.directory?(path)
        path
      end

      def git(command)
        #
        # We need to override some of the variable's git uses for generating
        # the SHASUM for testing purposes
        #
        time = Time.at(680227200).utc.strftime('%c %z')
        env  = {
          'GIT_AUTHOR_NAME'     => 'gitmirror',
          'GIT_AUTHOR_EMAIL'    => 'gitmirror@test.com',
          'GIT_AUTHOR_DATE'     => time,
          'GIT_COMMITTER_NAME'  => 'gitmirror',
          'GIT_COMMITTER_EMAIL' => 'gitmirror@test.com',
          'GIT_COMMITTER_DATE'  => time,
        }

        system(env, "git #{command}")
      end
    end
  end
end
