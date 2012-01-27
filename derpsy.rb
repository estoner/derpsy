require "octokit"
require "awesome_print"
require_relative "./config.rb"

module Derpsy
  
  def self.client
    Octokit::Client.new :login => Derpsy.config[:login], :password => Derpsy.config[:password] 
  end

  module Retrieve
    def self.pull_requests(client, repo)
      ap "retrieve the pull requests"
      pulls = client.pull_requests repo
      pulls.each do |pull|
        pull.discussion = client.pull(repo, pull.number).discussion
      end
      pulls.delete_if { |pull| pull.discussion.last.type != "Commit" }
    end
  end

  module Repo
    def self.setup
      ap "set up repo"
      # git checkout [integration-branch]
      # git pull upstream [integration-branch]
      # git checkout -b derp
      # git fetch [requestor]
      # git merge [requestor] [integration-branch] **** ideally this would be specific commits in request ****
    end
  end

  module Test
    def self.setup
      ap "bundle install"
      # bundle install
    end

    def self.run
      ap "run the tests"
      # reruns.each do { [test cmd with no weird formatting] if pass then return "passed" }
      # if fail then return "failed"
    end

    def self.interpret
      ap "interpret the results"
      # figure out what the F the test results mean
    end

    def self.cleanup
      ap "clean up the repo"
      # git checkout master
      # git branch -D derp
    end

  end

  module Notify

    def self.build_message
      ap "build the message"
      #   if no changes in features/*.feature update comments to complain no new tests
      #   in comment, mention time it took to run tests, # of reruns and which failed
      #   if more than 2 reruns, get snarky
      #   if hardcore, run simplecov and complain if not 100% coverage
    end

    def self.comment
      ap "post comment to GitHub"
      #   if failed, close request
    end

    def self.campfire
      ap "send notification to Campfire"
    end
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
