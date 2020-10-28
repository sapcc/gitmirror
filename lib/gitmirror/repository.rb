module Gitmirror
  class Repository

    attr_reader :url, :path
    def initialize url, path = nil
      @url= url
      @path = path ? File.expand_path(path) : default_path 
    end

    def mirror credential=nil
      backend.mirror(url, path, credential)
      path
    end

    def checkout(workdir, ref = 'master')
      backend.checkout(path, File.expand_path(workdir), ref)
    end

    def mirror_and_checkout(workdir, ref = 'master')
      mirror
      checkout(workdir, ref)
    end


    private

    def backend
      @backend ||=  case Gitmirror.backend 
                    when :fork
                      require 'gitmirror/backend/fork'
                      Gitmirror::Backend::Fork.new
                    when :posix_spawn
                      require 'gitmirror/backend/posix_spawn'
                      Gitmirror::Backend::PosixSpawn.new
                    else
                      raise "Unknown execution backend #{Gitmirror.backend}"
                    end
    end

    def default_path
      ::File.join Gitmirror.cache_dir, url.gsub(%r{[/:@]}, '_')
    end 

    def clone
    end

  end
end
