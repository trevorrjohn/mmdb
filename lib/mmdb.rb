require "mmdb/configuration"
require "mmdb/version"

module Mmdb
  class << self
    attr_reader :config

    def configure
      @config ||= Configuration.new
      yield(config) if block_given?
    end

    def reset
      @config = Configuration.new
      @db = nil
    end
  end
end
