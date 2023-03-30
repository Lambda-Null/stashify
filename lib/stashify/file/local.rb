# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    class Local < Stashify::File
      def contents
        ::File.read(path)
      end

      def write(contents)
        ::File.write(path, contents)
      end
    end
  end
end
