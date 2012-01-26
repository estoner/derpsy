require "octokit"
require "awesome_print"
require_relative "./config.rb"

# potential names
# cibbutz
# cicycle
# commentsy
# hubcicle
# neckbeard fairies
# cist
# cicada
# cistern
# cirrhosis
# ciao
# ciderp
# derpsy
# derpci
# derpspenders
# derphub
# hubsy

client = Octokit::Client.new :login => Derpsy.config[:login], :password => Derpsy.config[:password] 

client.pull_requests(Derpsy.config[:repo]).each do |req|
  discussion = client.pull(Derpsy.config[:repo], req.number).discussion
  if discussion.last.type == "Commit"
    ap discussion.last 
    # git checkout [integration-branch]
    # git pull upstream [integration-branch]
    # git checkout -b derp
    # git fetch [requestor]
    # git merge [requestor] [integration-branch] **** ideally this would be specific commits in request ****
    # bundle install
    # reruns.each do { [test cmd with no weird formatting] if pass then return "passed" }
    # if fail then return "failed"
    # update comments & Campfire:
    #   if failed, close request
    #   if no changes in features/*.feature update comments to complain no new tests
    #   in comment, mention time it took to run tests, # of reruns and which failed
    #   if more than 2 reruns, get snarky
    #   if hardcore, run simplecov and complain if not 100% coverage
    # git checkout master
    # git branch -D derp
  end
end

# sleep 15
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
#   clean up repo
