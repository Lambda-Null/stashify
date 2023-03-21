# frozen_string_literal: true

require "stashify/local"

RSpec.describe Stashify do
  it "has a version number" do
    expect(Stashify::VERSION).not_to be nil
  end

  describe Stashify::Local do
    pending "creates and reads files" do
      Dir.mktmpdir do |dir|
        stash = Stashify::Local.new(dir)
        file = Stashify::File.new(name: "foo.txt", contents: "bar")
        stash.create(file)
        expect(stash.read("foo.txt")).to eq(file)
      end
    end
  end
end
