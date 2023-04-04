# frozen_string_literal: true

require_relative "stashify/version"

module Stashify
  # Error raised when the filename given is invalid. This most likely
  # means the name parameter contains a "/".
  class InvalidFile < StandardError; end
end
