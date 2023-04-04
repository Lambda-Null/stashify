# frozen_string_literal: true

require "stashify/file/local"
require "stashify/directory"

module Stashify
  class Directory
    # An implementation for interacting with local directories. The
    # constructor needs no information on top of what is included
    # {Stashify::Directory#initialize}, although it's important to
    # note that setting the files parameter will not do anything.
    class Local < Stashify::Directory
      # Mostly uses the default implementaiton, but needs to create
      # the directory first so it has a valid destination.
      def write_directory(directory)
        FileUtils.mkdir(path_of(directory.name))
        super
      end

      def parent
        Stashify::Directory::Local.new(path: ::File.dirname(path))
      end

      def exists?(name)
        ::File.exist?(path_of(name))
      end

      def files
        Dir.entries(path).grep_v(/^[.][.]?$/).map do |file_name|
          find(file_name)
        end
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
    end
  end
end
