# frozen_string_literal: true

require "rantly/rspec_extensions"

require "stashify"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module SpecHelper
  def self.file_properties
    Rantly(100) do
      name = string
      guard name !~ %r{/}
      [name, string]
    end
  end
end
