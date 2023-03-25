# frozen_string_literal: true

require "stashify/local"

RSpec.describe Stashify do
  it "has a version number" do
    expect(Stashify::VERSION).not_to be nil
  end
end
