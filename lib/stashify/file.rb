# frozen_string_literal: true

require "stashify"

module Stashify
  # A common abstraction for interacting with files. All methods that
  # need to interact with files are assumed to adhere to the methods
  # defined here. Specifically the methods {#write}, {#delete},
  # {#contents} and {#exists?} are guaranteed to exist and behave in a
  # way that is consistent across all gems. Unless called out
  # separately, documentation for those methods here will hold true of
  # any implementations of this class.
  class File
    # Provides the contents of this file. In the base class, this is
    # implemented as an attribute, but most implementations will
    # override this with a method. In most implementations, the
    # performance cost of reading the file is high enough that we only
    # want to pay it if it's actually needed.
    attr_reader :contents

    # The name of the file is the actual filename in a directory. In
    # other words, it is everything that follows the final "/" in the
    # {#path}. This is always guaranteed to be populated.
    attr_reader :name

    # The full path to the file this represents. Anything after the
    # final "/" will also be returned from {#name}. This is not
    # necessarily guaranteed to be populated, but usually will be.
    attr_reader :path

    # Basic information associated with a file that is necessary to
    # enable memory-based interactions.
    #
    # @param name [String not containing a "/"] The name of the file. Either this or path must be defined.
    # @param path [String] The path of the file, will populate name with everything following the final "/".
    # @param contents [String] The contents of the file, if nil this object will mimic a missing file.
    def initialize(name: nil, path: nil, contents: nil)
      raise StandardError, "name or path must be defined" unless name || path
      raise Stashify::InvalidFile, "Name '#{name}' contains a /" if name && name =~ %r{/}

      @path = path
      @name = name || ::File.basename(path)
      @contents = contents
    end

    # Persists the provided contents into {#path}. If that file does
    # not exist, it creates it in the process. Otherwise it updates
    # the existing file.
    #
    # In general, if {#exists?} returns false before this is called it
    # will return true after this is called.
    #
    # @note For the base implementation, it will assign something to
    #   @contents. The value of this instance variable should not be
    #   relied upon outside of the base implementation though, every
    #   other implementation so far overrides to an action more
    #   appropriate to its storage medium.
    #
    # @param contents [String] A String describing the contents of the file.
    # @return No guarantees are made as to the return value of this method,
    #   it will largely depend on the implementation of the implementing class.
    def write(contents)
      @contents = contents
    end

    # Deletes the underlying file.
    #
    # In general, if {#exists?} returns true prior to this method
    # being called, it will no longer return true after this method is
    # called.
    #
    # @return No guarantees are made as to the return value of this method,
    #   it will largely depend on the implementation of the implementing class.
    def delete
      @contents = nil
    end

    # Answers if the file exists. In general, it will always return
    # true after {#write} is called and always return false after
    # {#delete} is called.
    #
    # @note The base class checks if {#contents} returns nil, but this
    #   is extremely unlikely for other implementations.
    def exists?
      !contents.nil?
    end

    # Two files are considered equal if they have the same name and
    # contents. This means that equality holds between files in two
    # separate directories.
    def ==(other)
      name == other.name && contents == other.contents
    end
  end
end
