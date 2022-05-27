# frozen_string_literal: true

require_relative "lib/rubocop/mdsol/version"

Gem::Specification.new do |spec|
  spec.name     = "rubocop-mdsol"
  spec.version  = RuboCop::Mdsol::VERSION
  spec.authors  = ["Team Æ", "Team 10"]
  spec.email    = ["ae@mdsol.com", "team10@mdsol.com"]
  spec.license  = "MIT"
  spec.summary  = "Base RuboCop configuration files for Ruby projects at Medidata"

  spec.metadata = {
    "homepage_uri" => "https://github.com/mdsol/rubocop-mdsol",
    "changelog_uri" => "https://github.com/mdsol/rubocop-mdsol/blob/develop/CHANGELOG.md"
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.required_ruby_version = ">= 2.6.0"
  spec.require_paths = ["lib"]

  spec.add_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "rspec", "~> 3.11"
  spec.add_development_dependency "rubocop-rspec", "~> 2.11"
end
