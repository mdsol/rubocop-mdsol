require "spec_helper"

RSpec.describe RuboCop::Cop::Mdsol::UnlessNotEqual, :config do
  it "registers an offense when using double negative: `unless` with a `!=` comparison" do
    expect_offense(<<~RUBY)
      do_something unless a != b
                   ^^^^^^^^^^^^^ Avoid double negative. Write `if a == b` instead.
    RUBY
  end

  it "does not register an offense when using if == comparison" do
    expect_no_offenses(<<~RUBY)
      do_something if a == b
    RUBY
  end

  it "does not register an offense when != is used in an elsif branch" do
    expect_no_offenses(<<~RUBY)
      if a == b
        do_this
      elsif b != c
        do_that
      end
    RUBY
  end
end
