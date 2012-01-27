require 'minitest/autorun'
require 'minitest/emoji'
require 'derpsy/test'

describe Derpsy::Test do
  it "must derp" do
    1.must_equal 1
  end
end
