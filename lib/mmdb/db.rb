module Mmdb
  class DB
    class InvalidFileFormat < RuntimeError ; end

    def initialize(file_path)
      @file_path = file_path
    end

    def query(ip_addr)
      validate_database!
      node = 0
      (decoder.start_index...128).each do |i|
        flag = (ip_addr >> (127 - i)) & 1
        next_node = decoder.read(node: node, flag: flag)
        raise InvalidFileFormat if next_node.zero?
        if next_node < decoder.node_count
          node = next_node
        else
          return decode_node(next_node).value
        end
      end
      raise InvalidFileFormat
    end

    private

    DATA_SEPARATOR_SIZE = 16

    attr_reader :file_path

    def validate_database!
      raise Mmdb::DatabaseNotFound unless File.exist?(file_path)
    end

    def decode_node(node)
      base = decoder.search_tree_size + DATA_SEPARATOR_SIZE
      position = (node - decoder.node_count) - DATA_SEPARATOR_SIZE
      decoder.decode(position: position, base: base)
    end

    def decoder
      @decode ||= Decoder.new(File.binread(file_path))
    end
  end
end
