# frozen_string_literal: true

module RuboCop
  module Cop
    module Mdsol
      # Favor the logger.<level>_with_data method for structured logging.
      #
      # @example
      #   # bad - string interpolations exceed the threshold (configurable via AllowedStringInterpolations setting)
      #   Rails.logger.info("a message with more than 2 interpolations: #{foo} #{bar} #{baz}")
      #
      #   # bad - string interpolation contains Enumerable methods (:map, :collect)
      #   Rails.logger.info("Deleted the following records: #{records.map(&:id)}")
      #
      #   # good
      #   Rails.logger.info("a message")
      #
      #   # good - string interpolations are within the threshold (configurable via AllowedStringInterpolations setting)
      #   Rails.logger.info("a message with 2 interpolations: #{foo} #{bar}")
      #
      #   # good
      #   Rails.logger.info_with_data("Created the record", record_id: record.id, status: status)
      #
      #   # good
      #   Rails.logger.info_with_data("Deleted the following records", record_ids: results.records.map(&:id))
      class LogWithData < Base
        MSG = "Use `logger.%<method>s_with_data(msg, data_hash)` instead. See https://github.com/mdsol/astinus#using-context-data-logging"

        RESTRICT_ON_SEND = %i[logger debug info warn error].freeze
        FORBIDDEN_ENUMERABLE_METHODS = %i[map collect].freeze
        DEFAULT_STRING_INTERPOLATION_THRESHOLD = 2

        # AST for code: `Rails.logger.debug("study creation request #{request} was status #{status}")`
        # (send
        #   (send
        #     (const nil :Rails) :logger) :debug
        #   (dstr
        #     (str "study creation request ")
        #     (begin
        #       (send nil :request))
        #     (str " was status ")
        #     (begin
        #       (send nil :status))))
        def_node_matcher :logger_with_interpolation, <<~PATTERN
          (send (send (const nil? $_) :logger) $_ $(dstr ...))
        PATTERN

        def on_send(node)
          logger_with_interpolation(node) do |logger_owner, log_method, log_message|
            return unless registered_logger_owners.include?(logger_owner.to_s)

            if interpoloations_exceed_threshold?(log_message) || contain_forbidden_enumerable_method?(log_message)
              msg = format(MSG, method: log_method.to_s)
              add_offense(node, message: msg)
            end
          end
        end

        private

        def registered_logger_owners
          @registered_logger_owners ||= (["Rails"] + cop_config["LoggerOwners"].to_a).uniq
        end

        def interpoloations_exceed_threshold?(log_message_node)
          log_message_node.child_nodes.count { |node| node.type == :begin } > string_interpolations_threshold
        end

        def string_interpolations_threshold
          cop_config["AllowedStringInterpolations"] || DEFAULT_STRING_INTERPOLATION_THRESHOLD
        end

        def contain_forbidden_enumerable_method?(log_message_node)
          log_message_node.each_descendant.any? do |descedant|
            descedant.send_type? && FORBIDDEN_ENUMERABLE_METHODS.include?(descedant.method_name)
          end
        end
      end
    end
  end
end
