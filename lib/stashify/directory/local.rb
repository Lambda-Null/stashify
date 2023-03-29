# frozen_string_literal: true

require "stashify/file/local"
require "stashify/directory"

module Stashify
  class Directory
    class Local < Stashify::Directory
      def write_directory(directory)
        FileUtils.mkdir(path_of(directory.name))
        super
      end

      def write_file(file)
        ::File.write(path_of(file.name), file.contents)
      end

      def files
        Dir.entries(path).grep_v(/^[.][.]?$/).map do |file_name|
          find(::File.basename(file_name))
        end
      end

      private

      def file?(name)
        ::File.exist?(path_of(name))
      end

      def file(name)
        Stashify::File::Local.new(path: path_of(name))
      end

      def directory?(name)
        ::File.directory?(path_of(name))
      end

      def directory(name)
        Stashify::Directory::Local.new(path: path_of(name))
      end

      def delete_directory(name)
        FileUtils.rm_r(path_of(name))
      end

      def delete_file(name)
        ::File.delete(path_of(name))
      end
    end
  end
end
