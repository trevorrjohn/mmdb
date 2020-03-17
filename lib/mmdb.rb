# frozen_string_literal: true

require 'mmdb/configuration'
require 'mmdb/db'
require 'mmdb/decoder'
require 'mmdb/query'
require 'mmdb/version'

module Mmdb
  class DatabaseNotFound < RuntimeError; end

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

    def db_for_key(file_key)
      databases.fetch(file_key) { raise DatabaseNotFound }
    end

    def databases
      @databases ||= Hash[config.files.map { |k, f| [k, DB.new(f)] }]
    end
  end
end
