module Derpsy
  module Retrieve
    def self.pull_requests(client, repo)
      Derpsy.logger.info "retrieve the pull requests"
      pulls = client.pull_requests repo
      pulls.each do |pull|
        pull.discussion = client.pull(repo, pull.number).discussion
      end
      pulls.delete_if { |pull| pull.discussion.last.type != "Commit" }
    end
  end
end
