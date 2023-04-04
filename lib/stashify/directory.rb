# frozen_string_literal: true

module Stashify
  # A common abstraction for interacting with directories. All methods
  # that need to interact with directories are assumed to adhere to
  # the public methods defined here. Specifically, the methods
  # {#find}, {#write}, {#delete}, and {#files} are guaranteed to exist
  # and behave in a way that is consistent across all gems. Unless
  # called out separately, documentation for those methods here will
  # hold true of any implementations of this class.
  class Directory
    # Provides the files and subdirectories of this directory. In the
    # base class, this is implemented as an attribute which defaults
    # to an empty list, but most implementations will override this
    # with a method. In most implementations, the performance cost of
    # reading all of thie names in a directory to construct these
    # objects is high enough that we only want to pay it if it's
    # actually needed.
    #
    # @return [Array<Stashify::File and Stashify::Directory>] Returns
    #   an Enumerable of Stashify::File and Stashify::Directory
    #   objects.
    attr_reader :files

    # The name of the directory. It is everything that follows the
    # final "/" in the {#path}. This is always guaranteed to be
    # populated.
    attr_reader :name

    # The full path to the directory this represents. Anything after the
    # final "/" will also be returned from {#name}. This is not
    # necessarily guaranteed to be populated, but usually will be.
    attr_reader :path

    # Basic information associated with a directory that is necessary
    # to enable memory-based interactions.
    #
    # @param name [String not containing a "/"] The name of the file. Either this or path must be defined.
    # @param path [String] The path of the file, will populate name with everything following the final "/".
    # @param files An array of Stashify::File and Stashify::Directory
    #   objects representing the contents of this directory.
    def initialize(name: nil, path: nil, files: [])
      raise StandardError, "name or path must be defined" unless name || path

      @path = path
      @name = name || ::File.basename(path)
      @files = files
    end

    # Look up the item in this directory represented by the provided
    # name.
    #
    # For those looking to implement this method, it's typically more
    # effective to override {#directory?}, {#directory}, {#exists?}
    # and {#file}. Unless there are performance concerns with calling
    # those, the default implementation will work pretty well.
    #
    # @param name [String with no "/"] The name of the desired item in
    #   this directory.
    #
    # @return Either a Stashify::File or Stashify::Directory object,
    #   depending on what that name represents.
    def find(name)
      if directory?(name)
        directory(name)
      elsif exists?(name)
        file(name)
      end
    end

    # Write the provided item into the directory. If the item is a
    # directory itself, then all of the contents will be copied.
    #
    # For those looking to implement this method, it's typically
    # easier to implement {#write_file} and {#write_directory}. This
    # helps you avoid having to know what type of object you're
    # dealing with.
    #
    # @param item Either a Stashify::File or Stashify::Directory
    #   object. Note that these can be any implementation of these
    #   base classes, it's not limited to the classes from the same
    #   provider.
    def write(item)
      if item.is_a?(Stashify::Directory)
        write_directory(item)
      else
        write_file(item)
      end
    end

    # Writes the provided directory. Typically you will want to
    # interact with this functionality through {#write} rather than
    # directly, as it protects you from errors related to accidentally
    # passing a Stashify::File value in. It is primarily implemented
    # separately to give a more specific hook for various
    # implementations.
    #
    # The default implementation might work for you, as it iterates
    # through {#files} and writes them to the new subdirectory.
    def write_directory(directory)
      subdir = self.directory(directory.name)
      directory.files.each { |file| subdir.write(file) }
    end

    # Writes the provided file. Typically you will want to interact
    # with this functionality through {#write} rather than directly,
    # as it protects you from errors related to accidentally passing a
    # Stashify::Directory value in. It is primarily implemented
    # separately to give a more specific hook for various
    # implementations.
    def write_file(file)
      file(file.name).write(file.contents)
    end

    # Delete provided name from the directory. If the item is a
    # directory itself, then all of the contents will be copied.
    #
    # For those looking to implement this method, it's typically
    # easier to implement {#directory?}, {#delete_directory} and
    # {#delete_file}. The primary reason to override this method would
    # be for performance reasons.
    #
    # @param name [String] Name of the item to be deleted.
    def delete(name)
      if directory?(name)
        delete_directory(name)
      else
        delete_file(name)
      end
    end

    # Deletes the provided directory name. Typically you will want to
    # interact with this functionality through {#delete} rather than
    # directly, as it protects you from errors related to accidentally
    # asking to delete a file as a directory.
    def delete_directory(name)
      subdir = directory(name)
      subdir.files.each { |file| subdir.delete(file.name) }
    end

    # Deletes the provided file name. Typically you will want to
    # interact with this functionality through {#delete} rather than
    # directly, as it protects you from errors related to accidentally
    # asking to delete a directory as a file.
    def delete_file(name)
      file(name).delete
    end

    # Two directories are equal if their files are equal. This is
    # distinct from being the same directory, which is served by the
    # {#eql?} method.
    def ==(other)
      files == other.files
    end

    # This answers if the two directories are the same, which is
    # usually more specific than you want. If you wish to determine if
    # all of the files are equal, consider {#==} instead..
    def eql?(other)
      self.class == other.class && name == other.name && path == other.path
    end

    # @return [Stashify::File] Return an object representing a single
    #   file in this directory.
    def file(name)
      Stashify::File.new(path: path_of(name))
    end

    # The full path to the item in this directory provided by the
    # names. Any number of names can be provided, allowing arbitrarily
    # deep paths to be constructed below this directory.
    def path_of(*names)
      ::File.join(path, *names)
    end
  end
end
