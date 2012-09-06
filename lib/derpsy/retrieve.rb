require_relative 'pull'
require 'hashie/mash'

module Derpsy
  
  module Retrieve
    
    def self.pull_request(client, repo)
      pull_list = client.pull_requests(repo)
      pull_list.each do |p|
        pull = client.pull(repo, p.number)
        commits = client.pull_request_commits(repo, pull.number)
        last_status = client.statuses(repo, commits.last.sha)
        return pull if pull.mergeable && last_status.length == 0
      end
      return false
    end

    def self.modelify(pull)
      id = pull.number
      hash = pull.head.sha
      repo = "git@github.com:#{pull.head.repository.owner}/rhapcom.git"
      # should check what branch to merge onto
      Derpsy::Pull.new id, hash, repo
    end

  end
end
