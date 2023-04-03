# frozen_string_literal: true

require "stashify/contract/directory_contract"

require "stashify/directory"
require "stashify/file"

RSpec.describe Stashify::Directory do
  let(:properties) do
    property_of do
      path = array(5) do
        dir = string
        guard dir !~ %r{/}
        dir
      end

      name1 = string
      name2 = string
      guard name1 !~ %r{/}
      guard name2 !~ %r{/}
      [File.join(path), name1, name2]
    end
  end

  include_context "directory setup", 100

  subject(:directory) do
    Stashify::Directory.new(path: path)
  end

  before(:each) do
    subject.write(
      Stashify::File.new(
        name: file_name,
        contents: contents,
      ),
    )
  end

  it "handles multiple arguments for path_of" do
    properties.check do |path, name1, name2|
      directory = Stashify::Directory.new(path: path)
      expect(directory.send(:path_of, name1, name2)).to eq(File.join(path, name1, name2))
    end
  end
end
