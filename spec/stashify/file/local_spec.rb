# frozen_string_literal: true

require "tmpdir"

require "stashify/file/local"

RSpec.describe Stashify::File::Local do
  around(:each) do |s|
    Dir.mktmpdir do |dir|
      @dir = dir
      s.run
    end
  end

  it "takes a path for the constructor" do
    SpecHelper.file_properties.each do |name, contents|
      path = File.join(@dir, name)
      File.write(path, contents)
      file = Stashify::File::Local.new(path)
      expect(file.name).to eq(name)
      expect(file.contents).to eq(contents)
    end
  end

  it "does not read the file until contents is called" do
    SpecHelper.file_properties.each do |name, contents|
      path = File.join(@dir, name)
      File.write(path, contents)
      expect(File).to_not receive(:read)
      Stashify::File::Local.new(path)
    end    
  end
end
