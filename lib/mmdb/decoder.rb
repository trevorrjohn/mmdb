module Mmdb
  class Decoder
    def initialize(data)
      @data = data
    end

    def metadata
      @metadata ||=
        begin
          index = data.rindex(METADATA_BEGIN)
          raise InvalidFileFormat if index.nil?
          decode(position: index + METADATA_BEGIN.size, base: 0).value
        end
    end

    def start_index
      @start_index ||= ip_version == 4 ? 96 : 0
    end

    def ip_version
      metadata["ip_version"]
    end

    def node_count
      metadata["node_count"]
    end

    def node_byte_size
      @node_byte_size ||= metadata["record_size"] * 2 / 8
    end

    def search_tree_size
      @search_tree_size ||= node_count * node_byte_size
    end

    def record_byte_size
      @record_byte_size ||= node_byte_size / 2
    end

    def read(node:, flag:)
      position = node_byte_size * node
      middle = data[position + record_byte_size].ord if node_byte_size.odd?
      if flag.zero? # LEFT node
        val = fetch(position, 0)
        val += ((middle & 0xf0) << 20) if middle
      else # RIGHT node
        val = fetch(position + node_byte_size - record_byte_size, 0)
        val += ((middle & 0xf) << 24) if middle
      end
      val
    end

    def decode(position:, base:)
      ctrl = data[position + base].ord
      type = ctrl >> 5
      position += 1

      if type == POINTER
        decode_pointer(position, base, ctrl)
      else
        if type == EXTENDED_TYPE
          type = 7 + data[position + base].ord
          position += 1
        end

        size = ctrl & 0x1f
        if size >= 29
          byte_size = size - 29 + 1
          val = fetch(position, base, byte_size)
          position += byte_size
          size = val + SIZE_BASE_VALUES[byte_size]
        end

        case type
        when UTF8
          val = data[position + base, size].encode('utf-8', 'utf-8')
          Node.new(position + size, val)
        when DOUBLE
          val = data[position + base, size].unpack('G')[0]
          Node.new(position + size, val)
        when BYTE
          val = data[position + base, size]
          Node.new(position + size, val)
        when UINT16, UINT32, UINT64, UINT128
          val = fetch(position, base, size)
          Node.new(position + size, val)
        when MAP
          val = size.times.each_with_object({}) do |_, map|
            key_node = decode(position: position, base: base)
            val_node = decode(position: key_node.position, base: base)
            position = val_node.position
            map[key_node.value] = val_node.value
          end
          Node.new(position, val)
        when INT32
          v1 = data[position + base, size].unpack('N')[0]
          bits = size * 8
          val = (v1 & ~(1 << bits)) - (v1 & (1 << bits))
          Node.new(position + size, val)
        when ARRAY
          val = Array.new(size) do
            node = decode(position: position, base: base)
            position = node.position
            node.value
          end
          Node.new(position, val)
        when DATA_CACHE_CONTAINER
          raise 'TODO:'
        when END_MARKER
          Node.new(position, nil)
        when BOOLEAN
          Node.new(position, !size.zero?)
        when FLOAT
          val = data[position + base, size].unpack('g')[0]
          Node.new(position + size, val)
        end
      end
    end

    private

    attr_reader :data

    METADATA_BEGIN = ([0xAB, 0xCD, 0xEF].pack('C*') + 'MaxMind.com').encode('ascii-8bit', 'ascii-8bit')
    SIZE_BASE_VALUES = [0, 29, 285, 65821].freeze
    POINTER_BASE_VALUES = [0, 0, 2048, 526336].freeze
    Node = Struct.new(:position, :value)
    TYPES = [
      EXTENDED_TYPE        = 0,
      POINTER              = 1,
      UTF8                 = 2,
      DOUBLE               = 3,
      BYTE                 = 4,
      UINT16               = 5,
      UINT32               = 6,
      MAP                  = 7,
      INT32                = 8,
      UINT64               = 9,
      UINT128              = 10,
      ARRAY                = 11,
      DATA_CACHE_CONTAINER = 12,
      END_MARKER           = 13,
      BOOLEAN              = 14,
      FLOAT                = 15
    ].freeze

    def decode_pointer(position, base, ctrl)
      size = ((ctrl >> 3) & 0x3) + 1
      v1 = ctrl & 0x7
      v2 = fetch(position, base, size)
      pointer = (v1 << (8 * size)) + v2 + POINTER_BASE_VALUES[size]
      Node.new(position + size, decode(position: pointer, base: base).value)
    end

    def fetch(position, base, size = record_byte_size)
      bytes = data[position + base, size].unpack('C*')
      bytes.inject(0) { |r, v| (r << 8) + v }
    end
  end
end
