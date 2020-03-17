# frozen_string_literal: true

module Mmdb
  class DB
    class InvalidFileFormat < RuntimeError; end

    def initialize(file_path)
      @file_path = file_path
    end

    def query(ip_addr)
      validate_database!
      find_node!(ip_addr)
    end

    private

    DATA_SEPARATOR_SIZE = 16

    attr_reader :file_path

    def find_node!(ip_addr)
      (decoder.start_index...128).inject(0) do |node, i|
        next_node = read_next_node!(node, build_flag(ip_addr, i))
        return decode_node(next_node).value if next_node >= decoder.node_count

        next_node
      end
      raise InvalidFileFormat
    end

    def build_flag(ip_addr, index)
      (ip_addr >> (127 - index)) & 1
    end

    def read_next_node!(node, flag)
      decoder.read(node: node, flag: flag).tap do |next_node|
        raise InvalidFileFormat if next_node.zero?
      end
    end

    def validate_database!
      raise Mmdb::DatabaseNotFound unless File.exist?(file_path)
    end

    def decode_node(node)
      base = decoder.search_tree_size + DATA_SEPARATOR_SIZE
      position = (node - decoder.node_count) - DATA_SEPARATOR_SIZE
      decoder.decode(position: position, base: base)
    end

    def decoder
      @decoder ||= Decoder.new(File.binread(file_path))
    end
  end
end
