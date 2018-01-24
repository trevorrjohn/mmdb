module Mmdb
  class Configuration
    DEFAULT_FILE_KEY = :file

    attr_accessor :files

    def file_path=(file_path)
      @files = { DEFAULT_FILE_KEY => file_path }
    end
  end
end
