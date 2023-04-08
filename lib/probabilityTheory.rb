# frozen_string_literal: true

require_relative "probabilityTheory/version"
require_relative "probabilityTheory/features"
require_relative "probabilityTheory/cart"

include Features

module ProbabilityTheory
  class Error < StandardError; end
  # Your code goes here...
  def self.hello
    'hello'
  end
end
