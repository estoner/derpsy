module Derpsy
  
  module Retrieve
    
    def self.all_pull_requests(client, repo)
      Derpsy.logger.info "retrieve the pull requests"
      pulls = client.pull_requests(repo)

      pulls.each do |pull|
        pull.discussion = client.pull(repo, pull.number).discussion
      end
      pulls.delete_if { |pull| pull.discussion.last.type != "Commit" }
      pulls

    end

    def self.testable_pull_request(pulls)
      if pulls.length > 0
        pulls[0]
      else
        nil
      end
    end
  
  end
end
