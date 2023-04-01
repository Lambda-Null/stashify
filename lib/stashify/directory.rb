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
      elsif exists?(name)
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

    def write_file(file)
      file(file.name).write(file.contents)
    end

    def delete(name)
      if directory?(name)
        delete_directory(name)
      else
        delete_file(name)
      end
    end

    def delete_directory(name)
      subdir = directory(name)
      subdir.files.each { |file| subdir.delete(file.name) }
    end

    def delete_file(name)
      file(name).delete
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
