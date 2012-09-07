require File.expand_path('../derpsy', __FILE__)
require File.expand_path('../../config', __FILE__)

# make this take parameters for login/pw
client = Derpsy.client
config = Derpsy.config
repo = config[:repo]
dir = config[:working_directory]
upstream = "git@github.com:#{repo}.git"

loop do
  puts 'getting pull requests'
  raw_pull = Derpsy::Retrieve.pull_request(client, repo)
  pull = Derpsy::Retrieve.modelify(raw_pull)
  #pull = Derpsy::Retrieve.testable_pull_request(pulls)
  if pull

    puts 'got a pull request'

    puts 'setting up tests'
    localrepo = Derpsy::Test.setup(pull, dir, upstream)

    puts 'running tests'
    results = Derpsy::Test.run(config[:test_cmd], dir)

    puts 'cleaning up tests'
    Derpsy::Test.cleanup(dir)

    puts 'interpreting results'
    interpreted_results = Derpsy::Test.interpret(results)

    puts 'assembling notification message'
    message = Derpsy::Notify.build_message(interpreted_results)

    puts 'notifying github'
    Derpsy::Notify.comment(pull, message, config)

    puts 'notifying campfire'
    Derpsy::Notify.campfire(pull, message, config)
  end
  sleep 15
end
