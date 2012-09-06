require_relative "./derpsy"
require_relative "../config"

# make this take parameters for login/pw
client = Derpsy.client
config = Derpsy.config
repo = config[:repo]
dir = config[:working_directory]
upstream = "git@github.com:#{repo}.git"

loop do
  puts 'getting pull requests'
  pull = Derpsy::Retrieve.pull_request(client, repo)
  #pull = Derpsy::Retrieve.testable_pull_request(pulls)
  if pull
    puts 'got a pull request'
    puts 'setting up tests'
    localrepo = Derpsy::Test.setup(pull, dir, upstream)
    puts 'running tests'
    results = Derpsy::Test.run(config[:test_cmd], dir)
    puts 'cleaning up tests'
    Derpsy::Test.cleanup(dir)
    puts 'assembling notification message'
    message = Derpsy::Notify.build_message(results)
    puts 'notifying github'
    Derpsy::Notify.comment(pull, message)
    puts 'notifying campfire'
    Derpsy::Notify.campfire(message)
  end
  sleep 15
end
