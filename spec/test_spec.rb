require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'
require 'derpsy/test'
require_relative "../config.rb"

$setupconf = Derpsy.config
pull = Derpsy::Pull.new(132, "27f906b9d1e51855f085db4da6b96998d84c45f7", "git@github.com:estoner/acts_as_test_repository.git")
Derpsy::Test.setup(pull, $setupconf[:working_directory], "git@github.com:#{$setupconf[:repo]}.git" )

describe Derpsy::Test do
  before do
    @conf = Derpsy.config
    @pwd = @conf[:working_directory] + "/repo"
  end

  describe "when it sets up the test repo" do

    it "must be a valid repo" do
      Dir.chdir @pwd do
        `git rev-parse --git-dir`
        $?.to_i.must_equal 0
      end
    end

    it "must set the expected hash to HEAD" do
      Dir.chdir @pwd do
        hash = `git log --pretty=format:'%h' -n 1`
        hash.must_equal "27f906b"
      end
    end

#    it "must have the correct bundle installed" do
#      msg = IO.popen("bundle check").readlines.first
#      msg.must_equal "The Gemfile's dependencies are satisfied\n"
#    end
#
  end

  describe "when it runs the tests" do
    
    it "should pass passing tests" do
      Derpsy::Test.run(@conf[:test_cmd], @conf[:working_directory]).must_equal true
    end

  end

  MiniTest::Unit.after_tests do
    Derpsy::Test.cleanup $setupconf[:working_directory]
  end

end
  
