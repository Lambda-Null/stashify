# frozen_string_literal: true

require "tmpdir"
require "stashify/contract/directory_contract"

require "stashify/directory/local"
require "stashify/file"

RSpec.describe Stashify::Directory::Local do
  around(:each) do |s|
    Dir.mktmpdir do |dir|
      @dir = dir
      s.run
    end
  end

  include_context "directory setup", 100
  let(:full_path) { File.join(@dir, path) }

  around(:each) do |s|
    file_path = File.join(full_path, file_name)
    FileUtils.mkdir_p(full_path)
    File.write(file_path, contents)
    s.run
    FileUtils.rm_r(file_path) if File.exist?(file_path)
  end

  subject(:direcotry) do
    Stashify::Directory::Local.new(path: full_path)
  end

  it_behaves_like "a directory"
end
