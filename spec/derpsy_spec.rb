require 'minitest/autorun'
require 'minitest/emoji'
require 'controller'

describe Controller do
  it "must ensure it's on a known network" do
    Controller.check_network.must_equal true
  end
end
