module Derpsy
  
  module Retrieve
    
    def self.pull_requests
      Derpsy.logger.info "retrieve the pull requests"
      pulls = Derpsy.client.pull_requests(Derpsy.config[:repo])

      pulls.each do |pull|
        pull.discussion = Derpsy.client.pull(Derpsy.config[:repo], pull.number).discussion
      end
      pulls.delete_if { |pull| pull.discussion.last.type != "Commit" }
      pulls

    end
  
  end
end
