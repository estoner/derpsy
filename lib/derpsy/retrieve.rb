require_relative 'pull'
require 'hashie/mash'

module Derpsy
  
  module Retrieve
    
    def self.pull_request(client, repo)
      pull_list = client.pull_requests(repo)
      pull_list.each do |p|
        pull = client.pull(repo, p.number)
        return pull if pull.mergeable && pull.discussion.last.type == "Commit"
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
