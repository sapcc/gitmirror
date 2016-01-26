require "gitmirror/version"
require "gitmirror/repository"
require "gitmirror/log"
require "logger"

module Gitmirror

  class GitError < ::StandardError ; end

  class << self
    attr_writer :cache_dir, :backend, :logger

    def cache_dir
      @cache_dir ||= ENV.fetch('GITMIRROR_CACHE',"/tmp/gitmirror")
    end

    def backend
      @backend ||= :fork
    end

    def logger
      @logger ||= Logger.new("/dev/null")
    end 
  end


end
