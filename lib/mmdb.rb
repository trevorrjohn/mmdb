require "mmdb/configuration"
require "mmdb/db"
require "mmdb/decoder"
require "mmdb/query"
require "mmdb/version"

module Mmdb
  class DatabaseNotFound < RuntimeError ; end

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

    def query(ip)
      Query.new(db: db, ip: ip).fetch
    end

    private

    attr_reader :db

    def db
      @db ||= DB.new(config.file_path)
    end
  end
end
