require_relative "./derpsy"
require_relative "../config"

# make this take parameters for login/pw
client = Derpsy.client
repo = Derpsy.config[:repo]

loop do
  pulls = Derpsy::Retrieve.all_pull_requests(client, repo)
  pull = Derpsy::Retrieve.testable_pull_request(pulls)
  if pull
    repo = Derpsy::Repo.setup(repo)
    Derpsy::Test.setup(repo)
    results = Derpsy::Test.run(repo)
    interpretation = Derpsy::Test.interpret(results)
    Derpsy::Test.cleanup(repo)
    message = Derpsy::Notify.build_message(interpretation)
    Derpsy::Notify.comment(message)
    Derpsy::Notify.campfire(message)
  end
  sleep 15
end
