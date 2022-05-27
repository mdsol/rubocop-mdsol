# frozen_string_literal: true

module RuboCop
  module Cop
    module Mdsol
      # Avoid double negative condition.
      #
      # @example
      #   # bad
      #   do_something unless a != b
      #
      #   # good
      #   do_something if a == b
      #
      # Credit to Warut: https://github.com/mdsol/tenjin/pull/621#discussion_r748106992
      class UnlessNotEqual < Base
        extend AutoCorrector

        MSG = "Avoid double negative. Write `%<correction>s` instead."

        # AST for: `do_something unless a != b`
        # (if
        #   (send
        #     (send nil :a) :!=
        #     (send nil :b)) nil
        #   (send nil :do_something))
        def_node_matcher :unless_not_equal_match, <<~PATTERN
          (if $(send $(...) :!= $(...)) ...)
        PATTERN

        def on_if(node)
          return if node.ternary? || node.if? || node.elsif?

          unless_not_equal_match(node) do |unless_body_node, left, right|
            correction = "if #{left.source} == #{right.source}"
            msg = format(MSG, correction: correction)
            range = range_with_unless_modifier(unless_body_node)

            add_offense(range, message: msg) do |corrector|
              corrector.replace(range, correction)
            end
          end
        end

        private

        def range_with_unless_modifier(unless_body_node)
          leading_unless = "unless "
          expand_range_to_left_by(unless_body_node, leading_unless.size)
        end

        def expand_range_to_left_by(node, length)
          source_range = node.source_range
          source_buffer = source_range.source_buffer
          Parser::Source::Range.new(source_buffer, source_range.begin_pos - length, source_range.end_pos)
        end
      end
    end
  end
end
