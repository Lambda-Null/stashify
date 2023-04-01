# frozen_string_literal: true

require "stashify/contract/file_contract"
require "tmpdir"

require "stashify/file/local"

RSpec.describe Stashify::File::Local do
  around(:each) do |s|
    Dir.mktmpdir do |dir|
      @dir = dir
      s.run
    end
  end

  include_context "file setup", 100
  let(:full_path) { File.join(@dir, path) }

  before(:each) do
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, contents)
  end

  subject(:file) do
    Stashify::File::Local.new(path: full_path)
  end

  it_behaves_like "a file"

  it "does not read the file until contents is called" do
    expect(File).to_not receive(:read)
    subject
  end
end
