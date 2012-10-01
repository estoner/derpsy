require File.expand_path('../pull', __FILE__)
require 'hashie/mash'
require 'awesome_print'

module Derpsy
  
  module Retrieve
    
    def self.pull_request(client, repo)
      Derpsy.logger.info "retrieving pull requests"
      pull_list = client.pull_requests(repo)
      sorted_pull_list = pull_list.sort_by { |pull| pull.number }.reverse
      sorted_pull_list.each do |p|
        pull = client.pull(repo, p.number)
        commits = client.pull_request_commits(repo, pull.number)
        last_status = client.statuses(pull.head.repo.full_name, commits.last.sha)
        return pull if pull.mergeable && last_status.length == 0
      end
      return false
    end

    def self.modelify(pull)
      id = pull.number
      hash = pull.head.sha
      repo = pull.head.repo.clone_url
      short_repo = pull.head.repo.full_name
      user = pull.user.login
      title = pull.title
      web_url = pull._links.html
      # branch = pull.head.ref
      # should check what branch to merge onto
      Derpsy::Pull.new id, hash, repo, short_repo, user, title, web_url
    end

  end
end
