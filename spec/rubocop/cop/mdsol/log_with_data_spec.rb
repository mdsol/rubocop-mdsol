require "spec_helper"

RSpec.describe RuboCop::Cop::Mdsol::LogWithData, :config do
  context "with the default config" do
    it "registers an offense if string interpolations exceed the default threshold" do
      expect_offense(<<~RUBY)
        Rails.logger.debug("with 3 string interpolations #\{foo\} #\{bar\} #\{baz\}")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `logger.debug_with_data(msg, data_hash)` instead. See https://github.com/mdsol/astinus#using-context-data-logging
      RUBY
    end

    it "does not register an offense if string interpolations does not exceed the default threshold" do
      expect_no_offenses(<<~RUBY)
        Rails.logger.debug("with 1 string interpolations #\{foo\}")
      RUBY
    end
  end

  context "when AllowedStringInterpolations is configured" do
    let(:cop_config) { { "AllowedStringInterpolations" => 1 } }

    it "registers an offense if string interpolations exceed the configured threshold" do
      expect_offense(<<~RUBY)
        Rails.logger.debug("with 2 string interpolations #\{foo\} #\{bar\}")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `logger.debug_with_data(msg, data_hash)` instead. See https://github.com/mdsol/astinus#using-context-data-logging
      RUBY
    end

    it "does not register an offense if string interpolations does not exceed the configured threshold" do
      expect_no_offenses(<<~RUBY)
        Rails.logger.debug("with 1 string interpolation #\{foo\}")
      RUBY
    end
  end

  context "when forbidden Enumerable methods are used in string interpolation" do
    it "registers an offense (shortcut)" do
      expect_offense(<<~RUBY)
        Rails.logger.info("Deleted the following records: #\{records.map(&:id)\}")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `logger.info_with_data(msg, data_hash)` instead. See https://github.com/mdsol/astinus#using-context-data-logging
      RUBY
    end
  end

  context "when allowed Enumerable methods are used in string interpolation" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        Rails.logger.info("Deleted #\{records.size\} records")
      RUBY
    end
  end

  context "when LoggerOwners is configured" do
    let(:cop_config) { { "LoggerOwners" => ["Utils"] } }

    it "checks against the configured logger" do
      expect_offense(<<~RUBY)
        Utils.logger.debug("with 3 string interpolations #\{foo\} #\{bar\} #\{baz\}")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `logger.debug_with_data(msg, data_hash)` instead. See https://github.com/mdsol/astinus#using-context-data-logging
      RUBY
    end

    it "checks against the default logger (Rails) as well" do
      expect_offense(<<~RUBY)
        Rails.logger.debug("with 3 string interpolations #\{foo\} #\{bar\} #\{baz\}")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `logger.debug_with_data(msg, data_hash)` instead. See https://github.com/mdsol/astinus#using-context-data-logging
      RUBY
    end
  end

  context "when LoggerOwners is not configured" do
    it "does not check the offenses" do
      expect_no_offenses(<<~RUBY)
        Utils.logger.debug("with 3 string interpolations #\{foo\} #\{bar\} #\{baz\}")
      RUBY
    end
  end

  it "does not register an offense when using logger.{method}_with_data" do
    expect_no_offenses(<<~RUBY)
      Rails.logger.debug_with_data("study creation", request: request, status: status)
    RUBY
  end
end
