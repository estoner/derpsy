require_relative "./derpsy"
require_relative "../config"

# make this take parameters for login/pw
client = Derpsy.client
repo = Derpsy.config[:repo]
dir = Derpsy.config[:working_directory]
upstream = "git@github.com:#{repo}.git"

loop do
  pulls = Derpsy::Retrieve.all_pull_requests(client, repo)
  pull = Derpsy::Retrieve.testable_pull_request(pulls)
  if pull
    localrepo = Derpsy::Test.setup(pull, dir, upstream)
    results = Derpsy::Test.run(localrepo)
    Derpsy::Test.cleanup(localrepo)
    message = Derpsy::Notify.build_message(results)
    Derpsy::Notify.comment(pull, message)
    Derpsy::Notify.campfire(message)
  end
  sleep 15
end
