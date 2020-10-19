# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name     = "rubocop-mdsol"
  spec.version  = "0.1.0"
  spec.authors  = ["Team Æ", "Team 10"]
  spec.email    = ["ae@mdsol.com", "team10@mdsol.com"]
  spec.license  = "MIT"
  spec.summary  = "Base RuboCop configuration files for Ruby projects at Medidata"

  spec.metadata = {
    "homepage_uri" => "https://github.com/mdsol/rubocop-mdsol",
    "changelog_uri" => "https://github.com/mdsol/rubocop-mdsol/blob/develop/CHANGELOG.md"
  }

  spec.files    = Dir[
    "CHANGELOG.md",
    "MIT-LICENSE",
    "README.md",
    "rubocop-mdsol.gemspec",
    "rubocop-rails.yml",
    "rubocop.yml"
  ]

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_dependency "rubocop", "~> 0.82"
end
