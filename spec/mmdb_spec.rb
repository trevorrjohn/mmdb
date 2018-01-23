require 'json'

RSpec.describe Mmdb do
  it "has a version number" do
    expect(Mmdb::VERSION).not_to be nil
  end

  describe ".query" do
    context "when VPN data" do
      before do
        Mmdb.configure do |c|
          c.file_path = "./spec/data/vpn_data.mmdb"
        end
      end

      context "when IP is in db" do
        it "returns the raw data" do
          ip = '1.2.236.218'
          result = Mmdb.query(ip)
          expected = JSON.load(open("./spec/data/fixtures/vpn_#{ip}.json"))
          expect(result).to eq(expected)
        end
      end

      context "when IP is not in db" do
        it "returns empty hash" do
          expect(Mmdb.query('192.168.1.1')).to eq({})
        end
      end
    end

    context "when City data" do
      before do
        Mmdb.configure do |c|
          c.file_path = "./spec/data/GeoLite2-City.mmdb"
        end
      end

      context 'when IPV6' do
        context "when IP is in db" do
          it "returns the raw data" do
            ip = '2001:708:510:8:9a6:442c:f8e0:7133'
            result = Mmdb.query(ip)
            expected = JSON.load(open("./spec/data/fixtures/city_#{ip}.json"))
            expect(result).to eq(expected)
          end
        end

        context "when IP is not in db" do
          it "returns nil" do
            expect(Mmdb.query('::FFFF:192.168.1.1')).to eq({})
          end
        end
      end

      context 'when IPV4' do
        context "when IP is in db" do
          it "returns the raw data" do
            ip = '74.125.225.224'
            result = Mmdb.query(ip)
            expected = JSON.load(open("./spec/data/fixtures/city_#{ip}.json"))
            expect(result).to eq(expected)
          end
        end

        context "when IP is not in db" do
          it "returns nil" do
            expect(Mmdb.query('192.168.1.1')).to eq({})
          end
        end
      end
    end

    context "when Country data" do
      before do
        Mmdb.configure do |c|
          c.file_path = "./spec/data/GeoLite2-Country.mmdb"
        end
      end

      context "when IP is in db" do
        it "returns the raw data" do
          ip = '74.125.225.224'
          result = Mmdb.query(ip)
          expected = JSON.load(open("./spec/data/fixtures/country_#{ip}.json"))
          expect(result).to eq(expected)
        end
      end

      context "when IP is not in db" do
        it "returns nil" do
          expect(Mmdb.query('192.168.1.1')).to eq({})
        end
      end
    end
  end

  after { Mmdb.reset }
end
