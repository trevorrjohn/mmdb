# MaxMindDB

[![Gem Version](https://badge.fury.io/rb/pure_mmdb.svg)](https://badge.fury.io/rb/pure_mmdb)
[![Build Status](https://travis-ci.org/trevorrjohn/mmdb.svg?branch=master)](https://travis-ci.org/trevorrjohn/mmdb)
[![Maintainability](https://api.codeclimate.com/v1/badges/7eb3d3e1389a8c16a2da/maintainability)](https://codeclimate.com/github/trevorrjohn/mmdb/maintainability)

The purpose of this gem is to implement the [MaxMindDB File Format](http://maxmind.github.io/MaxMind-DB/) in Ruby. 

The gem is highly influenced by the implementation of the [MaxMindDB gem](https://github.com/yhirose/maxminddb) and I have to give a lot of credit to that project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pure_mmdb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pure_mmdb

## Usage

### Configuration

To configure the gem, simply set the `file_path` in the configure block.

```ruby
Mmdb.configure do |c|
  c.file_path = '/path/to/db.mmdb'
end
Mmdb.query('192.168.1.1')
#=> { 'data' => 'hash' }
```

### Multiple Database Files

If you need to have multiple database files you can query each file individually after specifying the files. You can configure as many database files as you like. The database will only be loaded into memory once it is queried.

```ruby
Mmdb.configure do |c|
  c.files = {
    vpn: 'path to vpn.mmdb',
    location: 'path to location.mmdb'
  }
end
Mmdb.lookup('192.168.1.1', file_key: :vpn)
#=> { 'data' => 'vpn data' }
Mmdb.lookup('192.168.1.1', file_key: :location)
#=> { 'data' => 'location data' }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trevorrjohn/mmdb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.  
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mmdb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/trevorrjohn/mmdb/blob/master/CODE_OF_CONDUCT.md).
