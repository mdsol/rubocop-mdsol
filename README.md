# RuboCop Mdsol

This gem provides base RuboCop configuration files for Ruby projects at Medidata.


## Installation

Add the following line to your application's Gemfile:

```ruby
gem "rubocop-mdsol", "~> 0.3"
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
inherit_gem:
  rubocop-mdsol: rubocop.yml

# your customizations here...
```

### RSpec

To lint RSpec files, add the [rubocop-rpec](https://rubygems.org/gems/rubocop-rspec) gem to your Gemfile and in your RuboCop configuration require it alongside the RSpec-specific yaml file:

```yaml
require: rubocop-rspec

inherit_gem:
  rubocop-mdsol:
    - rubocop.yml
    - rubocop-rspec.yml

# your customizations here...
```

### Custom Cops

To activate the custom cops (`mdsol/*`) shipped with this Gem:

```yaml
require: rubocop-mdsol

# or using the array notation to specify multiple extensions:

require:
  - rubocop-mdsol
  - rubocop-rails
```

All cops are located under
[`lib/rubocop/cop/mdsol`](lib/rubocop/cop/mdsol) and contain examples/documentation.


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
