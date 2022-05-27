# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/mdsol'
require_relative 'rubocop/mdsol/version'
require_relative 'rubocop/mdsol/inject'

RuboCop::Mdsol::Inject.defaults!

require_relative 'rubocop/cop/mdsol_cops'
