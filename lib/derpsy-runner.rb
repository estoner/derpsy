require_relative "./derpsy"
require_relative "../config"

# make this take parameters for login/pw
client = Derpsy.client
repo = Derpsy.config[:repo]

loop do
  Derpsy::Retrieve.pull_requests(client, repo)
  Derpsy::Repo.setup
  Derpsy::Test.setup
  Derpsy::Test.run
  Derpsy::Test.interpret
  Derpsy::Test.cleanup
  Derpsy::Notify.build_message
  Derpsy::Notify.comment
  Derpsy::Notify.campfire
  sleep 15
end
