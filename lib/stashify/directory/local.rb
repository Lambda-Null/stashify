# frozen_string_literal: true

require "stashify/file"
require "stashify/directory"

module Stashify
  class Directory
    class Local < Stashify::Directory
      attr_reader :path

      def initialize(path)
        @path = path
        super(name: ::File.basename(path))
      end

      def find(name)
        path = ::File.join(@path, name)
        if ::File.directory?(path)
          Stashify::Directory::Local.new(path)
        else
          file = ::File.read(path)
          Stashify::File.new(name: name, contents: file)
        end
      end

      def write(file)
        path = ::File.join(@path, file.name)
        if file.is_a?(Stashify::Directory)
          FileUtils.mkdir(path)
        else
          ::File.write(path, file.contents)
        end
      end

      def delete(name)
        path = ::File.join(@path, name)
        if ::File.directory?(path)
          FileUtils.rm_r(path)
        else
          ::File.delete(path)
        end
      end

      def ==(other)
        @path == other.path
      end
    end
  end
end
