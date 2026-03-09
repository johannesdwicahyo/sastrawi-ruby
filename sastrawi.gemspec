# frozen_string_literal: true

require_relative "lib/sastrawi/version"

Gem::Specification.new do |spec|
  spec.name          = "sastrawi"
  spec.version       = Sastrawi::VERSION
  spec.required_ruby_version = ">= 3.0.0"
  spec.authors       = ["Andrias Meisyal", "Johannes Dwi Cahyo"]
  spec.email         = ["andriasonline@gmail.com"]

  spec.summary       = "Indonesian language stemmer for Ruby"
  spec.description   = "A Ruby library for stemming words in Bahasa Indonesia (Indonesian). " \
                        "Based on the Nazief & Adriani algorithm with Enhanced Confix Stripping."
  spec.homepage      = "https://github.com/johannesdwicahyo/sastrawi-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
end
