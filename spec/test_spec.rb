require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'
require 'derpsy/test'
require_relative "../config.rb"

describe Derpsy::Test do

  before do
    conf = Derpsy.config
    pull = Derpsy::Pull.new(132, "005e9f32df3e39d4caf6bbe2abb892dd4f0620af", "git@github.com:estoner/rhapcom.git")
    Derpsy::Test.setup(pull, conf[:working_directory], "git@github.com:#{conf[:repo]}.git" )
  end

  describe "when it sets up the test repo" do

    it "must be a valid repo" do
      `git rev-parse --git-dir`
      $?.to_i.must_equal 0
    end

#    it "must set the expected hash to HEAD" do
#      hash = IO.popen("git show-ref HEAD").readlines[0].split(" ").first
#      hash.must_equal "89adf24e940ac8b22da6f0da52e57d55bc5b7848"
#    end
#
#    it "must have the correct bundle installed" do
#      msg = IO.popen("bundle check").readlines.first
#      msg.must_equal "The Gemfile's dependencies are satisfied\n"
#    end
#
  end
  
  after do
    Derpsy::Test.cleanup    
  end

end
