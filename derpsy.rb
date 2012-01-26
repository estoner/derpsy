require "octokit"
require "awesome_print"
require_relative "./config.rb"

module Derpsy
  
  client = Octokit::Client.new :login => Derpsy.config[:login], :password => Derpsy.config[:password] 

  module Retrieve
    def self.pull_requests(client)

      client.pull_requests(Derpsy.config[:repo]).each do |req|
        discussion = client.pull(Derpsy.config[:repo], req.number).discussion
        ap discussion.last

        if discussion.last.type == "Commit"
          ap discussion.last 
        end
      end
    end
  end

  # this should probably really just hold the pull req data...Retrieve should get all pulls where last.type == "Commit"
  module Pulls
    def self.something(pulls, client)

      pulls.each do |req|
        discussion = client.pull(Derpsy.config[:repo], req.number).discussion
        ap discussion.last

        if discussion.last.type == "Commit"
          ap discussion.last 
        end
      end

    end
  end
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
  #
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
  #   clean up repos

end
