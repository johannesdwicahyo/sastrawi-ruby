# frozen_string_literal: true

require_relative "lib/sastrawi/version"

Gem::Specification.new do |spec|
  spec.name          = "sastrawi-ruby"
  spec.version       = Sastrawi::VERSION
  spec.required_ruby_version = ">= 3.0.0"
  spec.authors       = ["Johannes Dwi Cahyo"]
  spec.email         = ["csk.rage@gmail.com"]

  spec.summary       = "Indonesian language stemmer for Ruby"
  spec.description   = "A maintained fork of the sastrawi gem. Stems words in Bahasa Indonesia " \
                        "using the Nazief & Adriani algorithm with Enhanced Confix Stripping. " \
                        "Based on the original work by Andrias Meisyal (sastrawi gem) and the " \
                        "PHP Sastrawi project (github.com/sastrawi/sastrawi)."
  spec.homepage      = "https://github.com/johannesdwicahyo/sastrawi-ruby"
  spec.license       = "MIT"

  spec.metadata      = {
    "source_code_uri" => "https://github.com/johannesdwicahyo/sastrawi-ruby",
    "changelog_uri" => "https://github.com/johannesdwicahyo/sastrawi-ruby/blob/master/README.md",
    "upstream_uri" => "https://github.com/meisyal/sastrawi-ruby"
  }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
end
