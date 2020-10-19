# RuboCop Mdsol

This gem provides base RuboCop configuration files for Ruby projects at Medidata.


## Installation

Add the following lines to your application's Gemfile:

```ruby
git_source(:github) { |repo| "git@github.com:#{repo}.git" }

group :development, :test do
  gem "rubocop-mdsol", github: "mdsol/rubocop-mdsol", tag: "<latest tag>"
end
```


## Usage

In your project's RuboCop configuration file, you need to import the files provided by this gem.

Additionally, if you installed this gem using Bundler you will need to run RuboCop using `bundle exec rubocop`.

### Rails applications

From version 0.72.0, the Rails cops have been extracted to the [rubocop-rails](https://rubygems.org/gems/rubocop-rails) gem.
You will need to add this gem to your Gemfile and in your RuboCop configuration require it alongside the Rails-specific yaml file:

```yaml
require: rubocop-rails

inherit_gem:
  rubocop-mdsol:
    - rubocop.yml
    - rubocop-rails.yml

# your customizations here...
```

### Plain ruby projects (gems, lambdas...)

Plain ruby projects only need to inherit from the base configuration file:

```yaml
inherit_from:
  rubocop-mdsol: rubocop.yml

# your customizations here...
```


## Recommended customizations

### String literals

The `Style/StringLiterals` is disabled by default.
For the sake of consistency within your project, you definitely want to enable it with your preferred style:

```yaml
Style/StringLiterals:
  Enabled: true
  EnforcedStyle: double_quotes
  # or
  # EnforcedStyle: single_quotes
```
