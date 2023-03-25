# frozen_string_literal: true

require "tmpdir"

require "stashify/directory/local"
require "stashify/file"

RSpec.describe Stashify::Directory::Local do
  around(:each) do |s|
    Dir.mktmpdir do |dir|
      @dir = dir
      s.run
    end
  end

  it "reads a file" do
    SpecHelper.file_properties.each do |name, contents|
      File.write(File.join(@dir, name), contents)
      file = Stashify::Directory::Local.new(@dir).find(name)
      expect(file).to eq(Stashify::File.new(name: name, contents: contents))
    end
  end

  it "reads a directory" do
    SpecHelper.file_properties.each do |name, _|
      FileUtils.mkdir(File.join(@dir, name))
      dir = Stashify::Directory::Local.new(@dir).find(name)
      expect(dir).to eq(Stashify::Directory::Local.new(File.join(@dir, name)))
    end
  end

  it "writes a file" do
    SpecHelper.file_properties.each do |name, contents|
      Stashify::Directory::Local.new(@dir).write(Stashify::File.new(name: name, contents: contents))
      expect(File.read(File.join(@dir, name))).to eq(contents)
    end
  end

  it "writes a directory" do
    SpecHelper.file_properties.each do |name, _|
      Stashify::Directory::Local.new(@dir).write(Stashify::Directory.new(name: name))
      expect(File.directory?(File.join(@dir, name))).to be_truthy
    end
  end

  it "writes a directory's contents" do
    SpecHelper.file_properties.each do |name, contents|
      file = Stashify::File.new(name: name, contents: contents)
      source_dir = Stashify::Directory::Local.new(@dir)
      source_dir.write(file)
      Dir.mktmpdir do |target|
        target_dir = Stashify::Directory::Local.new(target)
        target_dir.write(source_dir)
        expect(target_dir.find(source_dir.name).find(name)).to eq(file)
      end
    end
  end

  it "deletes a file" do
    SpecHelper.file_properties.each do |name, contents|
      File.write(File.join(@dir, name), contents)
      Stashify::Directory::Local.new(@dir).delete(name)
      expect(File.exist?(File.join(@dir, name))).to be_falsey
    end
  end

  it "deletes a directory" do
    SpecHelper.file_properties.each do |name, _|
      path = File.join(@dir, name)
      FileUtils.mkdir(path)
      Stashify::Directory::Local.new(@dir).delete(name)
      expect(File.directory?(path))
    end
  end
end
