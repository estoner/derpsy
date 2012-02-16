require "octokit"
require_relative "../config.rb"
require "logger"
require "awesome_print"
require_relative "derpsy/retrieve"
require_relative "derpsy/repo"
require_relative "derpsy/test"
require_relative "derpsy/notify"

module Derpsy
  
  def self.logger
    @@logger = Logger.new(Derpsy.config[:working_directory] + "/derpsy.log")
  end
  
  def self.client
    Octokit::Client.new :login => Derpsy.config[:login], :password => Derpsy.config[:password] 
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
