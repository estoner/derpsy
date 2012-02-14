require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'
require 'derpsy/test'

describe Derpsy::Test do

  before do
    @pull = #marshalled pull

    it "must set up a local git repo when given a pull request" do
      @repo = Derpsy::Test.setup(@pull)
    end

  end

  it "must have the expected hash at HEAD" do
    1.must_equal 1
  end

end
