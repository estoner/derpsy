require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/pride'
require 'derpsy/retrieve'
require 'hashie/mash'
require 'awesome_print'

describe Derpsy::Retrieve do

  before do
    pull = File.open("spec/fixtures/pulls.marshal", "rb") {|file| Marshal.load(file)}
    @model = Derpsy::Retrieve.modelify(pull)
  end

  it "must be able to convert raw pull request data into a Derpsy::Pull" do
    @model.must_be_instance_of Derpsy::Pull
  end

  it "must produce the expected ID" do
    @model.id.must_equal 1
  end

  it "must produce the expected hash" do
    @model.hash.must_equal "27f906b9d1e51855f085db4da6b96998d84c45f7"
  end

  it "must produce the expected repo URL" do
    @model.repo.must_equal "git@github.com:estoner/rhapcom.git"
  end

end
