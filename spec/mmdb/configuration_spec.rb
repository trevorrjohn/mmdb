RSpec.describe Mmdb::Configuration do
  context 'with single file' do
    it 'allows you to set a signle file_path' do
      Mmdb.configure do |c|
        c.file_path = '/some/file/path'
      end
      expect(Mmdb.config.files)
        .to eq({ Mmdb::Configuration::DEFAULT_FILE_KEY => '/some/file/path' })
    end

    it 'resets the configuration' do
      Mmdb.configure do |c|
        c.file_path = '/some/file/path'
      end
      Mmdb.reset
      expect(Mmdb.config.files).to eq nil
    end
  end

  context 'with mutliple files' do
    it 'allows you to set the files' do
      Mmdb.configure do |c|
        c.files = { a: '/a/file', 'b' => '/b/file' }
      end
      expect(Mmdb.config.files).to eq({ a: '/a/file', 'b' => '/b/file' })
    end

    it 'resets the configuration' do
      Mmdb.configure do |c|
        c.files = { a: '/a/file', 'b' => '/b/file' }
      end
      Mmdb.reset
      expect(Mmdb.config.files).to eq nil
    end
  end
end
