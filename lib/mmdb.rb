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
      @databases = nil
    end

    def query(ip, file_key: Configuration::DEFAULT_FILE_KEY)
      Query.new(db: db_for_key(file_key), ip: ip).fetch
    end

    private

    attr_reader :databases

    def db_for_key(file_key)
      databases[file_key].tap do |db|
        raise DatabaseNotFound if db.nil?
      end
    end

    def databases
      @databases ||=
        config.files.map do |key, file_path|
          [key, DB.new(file_path)]
        end.to_h
    end
  end
end
