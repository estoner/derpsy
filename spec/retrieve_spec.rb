require 'minitest/autorun'
require 'minitest/emoji'
require 'derpsy/retrieve'

describe Derpsy::Retrieve do
  it "must find all untested pull requests" do
    relevant_pull_requests(mock_pulls).length.must_equal 2 
  end
end
