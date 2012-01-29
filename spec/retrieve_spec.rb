require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/emoji'
require 'derpsy/retrieve'
require 'json'
require 'hashie/mash'

describe Derpsy::Retrieve do
  before do
    @pulls = File.open("spec/fixtures/pulls.marshal", "rb") {|file| Marshal.load(file)}
  end

  # this is obviously stupid as it just tests a fixture, placeholder
  it "must find all untested pull requests" do
    @pulls.length.must_equal 1
  end
end
