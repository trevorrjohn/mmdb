
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mmdb/version"

Gem::Specification.new do |spec|
  spec.name          = "mmdb"
  spec.version       = Mmdb::VERSION
  spec.authors       = ["Trevor John"]
  spec.email         = ["trevor@john.tj"]

  spec.summary       = %q{This is a ruby implementation of the MaxMindDB file format}
  spec.description   = %q{The purpose of this gem is to provide fast IP lookups for the MaxMindDB file format without parsing the data stored.}
  spec.homepage      = "https://github.com/trevorrjohn/mmdb"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
