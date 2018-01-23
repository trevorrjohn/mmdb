RSpec.describe Mmdb::Configuration do
  it 'allows you to set the file_path' do
    Mmdb.configure do |c|
      c.file_path = '/some/file/path'
    end
    expect(Mmdb.config.file_path).to eq '/some/file/path'
  end

  it 'resets the configuration' do
    Mmdb.configure do |c|
      c.file_path = '/some/file/path'
    end
    Mmdb.reset
    expect(Mmdb.config.file_path).to eq nil
  end
end
