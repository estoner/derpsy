require File.expand_path('../derpsy', __FILE__)
require File.expand_path('../../config', __FILE__)

# make this take parameters for login/pw
client = Derpsy.client
config = Derpsy.config
campfire_room = Derpsy.campfire_room
repo = config[:repo]
dir = config[:working_directory]
upstream = "https://github.com/#{repo}"

loop do
  raw_pull = Derpsy::Retrieve.pull_request(client, repo)
  if raw_pull
    pull = Derpsy::Retrieve.modelify(raw_pull)
    #pull = Derpsy::Retrieve.testable_pull_request(pulls)
    if pull
      localrepo = Derpsy::Test.setup(pull, dir, upstream)
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
