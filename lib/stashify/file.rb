# frozen_string_literal: true

module Stashify
  class File
    attr_reader :name, :contents

    def initialize(name:, contents: "")
      @name = name
      @contents = contents
    end

    def ==(other)
      name == other.name && contents == other.contents
    end
  end
end
