# frozen_string_literal: true

require "stashify"

module Stashify
  class File
    attr_reader :name, :contents

    def initialize(name:, contents: "")
      raise Stashify::InvalidFile, "Name '#{name}' contains a /" if name =~ %r{/}

      @name = name
      @contents = contents
    end

    def ==(other)
      name == other.name && contents == other.contents
    end
  end
end
