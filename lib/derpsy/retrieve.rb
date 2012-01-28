module Derpsy
  
  module Retrieve
    
    def self.get_all_pull_requests(client, repo)
      pulls = client.pull_requests repo
      pulls.each do |pull|
        pull.discussion = client.pull(repo, pull.number).discussion
      end
      pulls
    end

    def self.relevant_pull_requests(pulls)
      pulls.delete_if { |pull| pull.discussion.last.type != "Commit" }
    end

    # wraps previous methods, so we can break them apart to enable easy mocking
    def self.pull_requests(client, repo)
      Derpsy.logger.info "retrieve the pull requests"
      pulls = relevant_pull_requests get_all_pull_requests(client, repo)
      Derpsy.logger.info ap(pulls)
      pulls
    end
  
  end
end
