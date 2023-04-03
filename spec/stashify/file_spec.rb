# frozen_string_literal: true

require "stashify/contract/file_contract"

require "stashify/file"

RSpec.describe Stashify::File do
  include_context "file setup", 100

  subject(:file) do
    Stashify::File.new(path: path, contents: contents)
  end

  before(:each) do
    file.write(contents)
  end

  it_behaves_like "a file"

  it "treats / as invalid in a name" do
    expect do
      Stashify::File.new(name: "a/b")
    end.to raise_error(Stashify::InvalidFile)
  end
end
