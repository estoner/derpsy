require "octokit"
require "tinder"
require File.expand_path('../../config', __FILE__)
require "logger"
require "awesome_print"
require File.expand_path('../derpsy/retrieve', __FILE__)
require File.expand_path('../derpsy/repo', __FILE__)
require File.expand_path('../derpsy/test', __FILE__)
require File.expand_path('../derpsy/notify', __FILE__)

module Derpsy
  
  def self.logger
    logger = Logger.new(Derpsy.config[:working_directory] + "/derpsy.log")
    logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    @@logger = logger
  end
  
  def self.client
    Octokit::Client.new :login => Derpsy.config[:login], :oauth_token => Derpsy.config[:oauth_token]
  end

  def self.campfire_room
    campfire = Tinder::Campfire.new Derpsy.config[:campfire_subdomain], :token => Derpsy.config[:campfire_token]
    room = campfire.find_room_by_name Derpsy.config[:campfire_room_name]
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
