require File.expand_path('../derpsy', __FILE__)
require File.expand_path('../../config', __FILE__)
require 'fileutils'

# make this take parameters for login/pw
client = Derpsy.client
config = Derpsy.config
campfire_room = Derpsy.campfire_room
repo = config[:repo]
dir = config[:working_directory]
branch = config[:branch]
token = config[:oauth_token]
FileUtils.mkdir_p dir
upstream = "https://github.com/#{repo}.git"

loop do
  raw_pull = Derpsy::Retrieve.pull_request(client, repo)
  if raw_pull
    pull = Derpsy::Retrieve.modelify(raw_pull)
    #pull = Derpsy::Retrieve.testable_pull_request(pulls)
    if pull
      localrepo = Derpsy::Test.setup(pull, dir, upstream, branch, token)
      results = Derpsy::Test.run(config[:test_cmd], dir)
      Derpsy::Test.cleanup(dir)
      interpreted_results = Derpsy::Test.interpret(results)
      message = Derpsy::Notify.build_message(interpreted_results)
      Derpsy::Notify.github(pull, message, config, client)
      Derpsy::Notify.campfire(pull, message, config, campfire_room)
    end
  end
  sleep 15
end
