# frozen_string_literal: true

require_relative "probabilityTheory/version"
require_relative "probabilityTheory/features"
require_relative "probabilityTheory/cart"
require_relative "probabilityTheory/dice"
require_relative "probabilityTheory/combinatorics.rb"

include Features
include Combinatorics

module ProbabilityTheory
  class Error < StandardError; end
  # Your code goes here...
end
