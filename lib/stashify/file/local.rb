# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    # An implementation for interacting with local files. The
    # constructor needs no information on top of what is included
    # {Stashify::File#initialize}, although it's important to note
    # that setting the contents parameter will not do anything.
    class Local < Stashify::File
      def contents
        ::File.read(path)
      end

      def write(contents)
        ::File.write(path, contents)
      end

      def delete
        ::File.delete(path)
      end

      def exists?
        ::File.exist?(path)
      end
    end
  end
end
