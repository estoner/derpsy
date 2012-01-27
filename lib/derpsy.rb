require "octokit"
require_relative "../config.rb"
require "logger"
require "awesome_print"
require "derpsy/retrieve"
require "derpsy/repo"
require "derpsy/test"
require "derpsy/notify"

module Derpsy
  
  def self.client
    Octokit::Client.new :login => Derpsy.config[:login], :password => Derpsy.config[:password] 
  end

  def self.logger
    @@logger = Logger.new("./derpsy.log")
  end

end

# handle errors throughout
#
# overall structure:
#   get the requests
#     get the discussion
#       if commit,
#         set up local repo for test
#         run test
#           rerun test
#         update comments/Campfire
#         clean up local repo
#   sleep
#
#  testing:
#   repo setup
#   interpret test results
#   rerun tests
#   update comments
#   update Campfire
#   clean up repos
