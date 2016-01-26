# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitmirror/version'

Gem::Specification.new do |spec|
  spec.name          = "gitmirror"
  spec.version       = Gitmirror::VERSION
  spec.authors       = ["Fabian Ruff"]
  spec.email         = ["fabian.ruff@progra.de"]

  spec.summary       = "gitmirror maintains mirrors of git repositories on the local system using a bare repository cache." 
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  #spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://***REMOVED***"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
