# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    class Local < Stashify::File
      def contents
        ::File.read(path)
      end
    end
  end
end
