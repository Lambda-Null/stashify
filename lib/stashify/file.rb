# frozen_string_literal: true

require "stashify"

module Stashify
  class File
    attr_reader :name, :path, :contents

    def initialize(name: nil, path: nil, contents: "")
      raise StandardError, "name or path must be defined" unless name || path
      raise Stashify::InvalidFile, "Name '#{name}' contains a /" if name && name =~ %r{/}

      @path = path
      @name = name || ::File.basename(path)
      @contents = contents
    end

    def ==(other)
      name == other.name && contents == other.contents
    end
  end
end
