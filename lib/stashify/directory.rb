# frozen_string_literal: true

module Stashify
  class Directory
    attr_reader :name, :files

    def initialize(name:, files: [])
      @name = name
      @files = files
    end

    def find(name)
      if directory?(name)
        directory(name)
      else
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
  end
end
