require 'ipaddr'

module Mmdb
  class Query
    def initialize(db:, ip:)
      @db = db
      @ip = ip
    end

    def fetch
      db.query(ip_addr.to_i)
    end

    private

    attr_reader :db, :ip

    def ip_addr
      addr = IPAddr.new(ip)
      addr.ipv4? ? addr.ipv4_compat : addr
    end
  end
end
