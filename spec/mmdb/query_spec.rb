# frozen_string_literal: true

RSpec.describe Mmdb::Query, '#fetch' do
  context 'when the query ip is not a valid ip' do
    it 'raises IPAddr::AddressFamilyError' do
      expect do
        Mmdb::Query.new(db: nil, ip: nil).fetch
      end.to raise_error(IPAddr::AddressFamilyError)
      expect do
        Mmdb::Query.new(db: nil, ip: '').fetch
      end.to raise_error(IPAddr::InvalidAddressError)
      expect do
        Mmdb::Query.new(db: nil, ip: 'bad ip').fetch
      end.to raise_error(IPAddr::InvalidAddressError)
    end
  end

  context 'when the query ip IPV4 IP Address' do
    it 'converts the IP to ipv4_compat' do
      result = double :result
      db = instance_double Mmdb::DB, query: result
      ip = '192.168.1.1'
      expect(Mmdb::Query.new(db: db, ip: ip).fetch).to eq result
      expect(db).to have_received(:query).with(3_232_235_777)
    end
  end

  context 'when query is IPV6 IP Address' do
    it 'converts the IP to integer' do
      result = double :result
      db = instance_double Mmdb::DB, query: result
      ip = '2001:708:510:8:9a6:442c:f8e0:7133'
      expect(Mmdb::Query.new(db: db, ip: ip).fetch).to eq result
      expect(db).to have_received(:query)
        .with(42_540_630_774_235_136_446_847_854_956_926_497_075)
    end
  end
end
