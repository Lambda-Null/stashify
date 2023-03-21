# frozen_string_literal: true

require "stashify/file"

RSpec.describe Stashify::File do
  it "has properties set" do
    properties.check do |name, contents|
      file = Stashify::File.new(name: name, contents: contents)
      expect(file.name).to eq(name)
      expect(file.contents).to eq(contents)
    end
  end

  it { expect(Stashify::File.new(name: "foo").contents).to eq("") }

  it "is equal" do
    properties.check do |name, contents|
      expect(Stashify::File.new(name: name, contents: contents))
        .to eq(Stashify::File.new(name: name, contents: contents))
    end
  end

  it "has unequal contents" do
    properties.check do |name, contents1, _, contents2|
      expect(Stashify::File.new(name: name, contents: contents1))
        .to_not eq(Stashify::File.new(name: name, contents: contents2))
    end
  end

  it "has unequal name" do
    properties.check do |name1, contents, name2|
      expect(Stashify::File.new(name: name1, contents: contents))
        .to_not eq(Stashify::File.new(name: name2, contents: contents))
    end
  end
end

def properties
  property_of do
    name1 = string
    contents1 = string
    name2 = string
    contents2 = string
    guard name1 != name2
    guard contents1 != contents2
    [name1, contents1, name2, contents2]
  end
end
