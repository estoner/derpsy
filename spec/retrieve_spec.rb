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
    @model.id.must_equal 2
  end

  it "must produce the expected hash" do
    @model.hash.must_equal "511b839072fd8b101c095001ba0c44532f4a0cda"
  end

  it "must produce the expected repo URL" do
    @model.repo.must_equal "https://github.com/estoner/acts_as_test_repository.git"
  end

end
