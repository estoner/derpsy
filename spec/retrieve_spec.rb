require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/pride'
require 'derpsy/retrieve'
require 'json'
require 'hashie/mash'
require 'awesome_print'

describe Derpsy::Retrieve do

  before do
    @pulls = File.open("spec/fixtures/pulls.marshal", "rb") {|file| Marshal.load(file)}
    @no_pulls = []
  end

  it "must have a fixture with one untested pull request" do
    @pulls.length.must_equal 1
  end

  it "must return an expected number of pulls from a known github repository" do
    # will be sloooooow
  end

  it "must include comments in the pull results" do
    # will be sloooooow
  end

  it "must return nil if there are no testable pull requests" do
    Derpsy::Retrieve.testable_pull_request(@no_pulls).must_be_nil
  end

  it "must return one Derpsy::Pull if there is a testable pull request" do
    Derpsy::Retrieve.testable_pull_request(@pulls).must_be_instance_of Derpsy::Pull
  end

end
