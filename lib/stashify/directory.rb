# frozen_string_literal: true

module Stashify
  class Directory
    attr_reader :name

    def initialize(name:)
      @name = name
    end
  end
end
