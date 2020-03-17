# frozen_string_literal: true

RSpec.describe Mmdb::DB, '#query' do
  context 'when file is not found' do
    it 'raise Mmdb::DatabaseNotFound' do
      expect do
        Mmdb::DB.new('./not-found.mmdb').query(nil)
      end.to raise_error Mmdb::DatabaseNotFound
    end
  end
end
