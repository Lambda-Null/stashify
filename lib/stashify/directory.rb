# frozen_string_literal: true

module Stashify
  class Directory
    attr_reader :name

    def initialize(name:)
      @name = name
    end

    def find(name)
      if directory?(name)
        directory(name)
      else
        file(name)
      end
    end
  end
end
