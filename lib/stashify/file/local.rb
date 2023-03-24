# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    class Local < Stashify::File
      def initialize(path)
        @path = path
        super(name: ::File.basename(path), contents: nil)
      end

      def contents
        ::File.read(@path)
      end
    end
  end
end
