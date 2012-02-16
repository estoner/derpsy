require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'
require 'derpsy/test'
require_relative "../config.rb"

describe Derpsy::Test do

  before do
    conf = Derpsy.config
    pull = Derpsy::Pull.new(132, "005e9f32df3e39d4caf6bbe2abb892dd4f0620af", "https://github.com/estoner/rhapcom")
    Derpsy::Test.setup(pull, conf[:working_directory], conf[:upstream])
    Dir.chdir(conf[:working_directory] + "/repo")
  end

  describe "when it sets up the test repo" do

    it "must be a valid repo" do
      msg = IO.popen("git rev-parse --git-dir").readlines.first
      msg.must_equal ".git\n"
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
    
  end

end
