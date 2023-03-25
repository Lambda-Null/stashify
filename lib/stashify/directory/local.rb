# frozen_string_literal: true

require "stashify/file/local"
require "stashify/directory"

module Stashify
  class Directory
    class Local < Stashify::Directory
      attr_reader :path

      def initialize(path)
        @path = path
        super(name: ::File.basename(path))
      end

      def write_directory(directory)
        FileUtils.mkdir(path_of(directory.name))
        super
      end

      def write_file(file)
        ::File.write(path_of(file.name), file.contents)
      end

      def delete(name)
        path = ::File.join(@path, name)
        if ::File.directory?(path)
          FileUtils.rm_r(path)
        else
          ::File.delete(path)
        end
      end

      def files
        Dir.entries(@path).grep_v(/^[.][.]?$/).map do |file_name|
          find(::File.basename(file_name))
        end
      end

      def ==(other)
        @path == other.path
      end

      private

      def directory?(name)
        ::File.directory?(path_of(name))
      end

      def file(name)
        Stashify::File::Local.new(path_of(name))
      end

      def directory(name)
        Stashify::Directory::Local.new(path_of(name))
      end

      def path_of(name)
        ::File.join(@path, name)
      end
    end
  end
end
