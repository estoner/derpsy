require File.expand_path('../derpsy', __FILE__)
require File.expand_path('../../config', __FILE__)
require 'fileutils'

# make this take parameters for login/pw
client = Derpsy.client
config = Derpsy.config
campfire_room = Derpsy.campfire_room
repo = config[:repo]
allowed_reruns = config[:allowed_reruns]
dir = config[:working_directory]
branch = config[:branch]
token = config[:github_token]
bundler_options = config[:bundler_options]
FileUtils.mkdir_p dir
upstream = "https://github.com/#{repo}.git"

loop do
  Derpsy.logger.debug "*************** starting loop ***************" 
  raw_pull = Derpsy::Retrieve.pull_request(client, repo, campfire_room)
  if raw_pull
    pull = Derpsy::Retrieve.modelify(raw_pull)
    #pull = Derpsy::Retrieve.testable_pull_request(pulls)
    if pull
      localrepo = Derpsy::Test.setup(pull, dir, upstream, branch, token, bundler_options)
      results = Derpsy::Test.run(config[:test_cmd], dir, allowed_reruns)
      Derpsy::Test.cleanup(dir)
      interpreted_results = Derpsy::Test.interpret(results)
      message = Derpsy::Notify.build_message(interpreted_results)
      Derpsy::Notify.github(pull, message, config, client)
      Derpsy::Notify.campfire(pull, message, config, campfire_room)
    end
  end
  Derpsy.logger.debug "*************** ending loop ***************" 
  sleep 15
end
