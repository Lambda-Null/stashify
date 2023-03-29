# frozen_string_literal: true

module Stashify
  class Directory
    attr_reader :name, :files, :path

    def initialize(name: nil, path: nil, files: [])
      raise StandardError, "name or path must be defined" unless name || path

      @path = path
      @name = name || ::File.basename(path)
      @files = files
    end

    def find(name)
      if directory?(name)
        directory(name)
      elsif file?(name)
        file(name)
      end
    end

    def write(file)
      if file.is_a?(Stashify::Directory)
        write_directory(file)
      else
        write_file(file)
      end
    end

    def write_directory(directory)
      subdir = self.directory(directory.name)
      directory.files.each { |file| subdir.write(file) }
    end

    def ==(other)
      files == other.files
    end

    def eql?(other)
      self.class == other.class && name == other.name && path == other.path
    end

    private

    def path_of(*name)
      ::File.join(path, *name)
    end
  end
end
