require File.expand_path('../pull', __FILE__)
require 'hashie/mash'
require 'awesome_print'

module Derpsy
  
  module Retrieve
    
    def self.pull_request(client, repo, campfire_room)
      Derpsy.logger.info "retrieving pull requests"
      pull_list = client.pull_requests(repo)
      last_master_commit = client.commits(repo, "master").last.sha
      sorted_pull_list = pull_list.sort_by { |pull| pull.number }
      sorted_pull_list.each do |p|
        pull = client.pull(repo, p.number)
        commits = client.pull_request_commits(repo, pull.number)
        last_status = ""
        last_commit_statuses = client.statuses(pull.head.repo.full_name, commits.last.sha)
        if last_commit_statuses[0]
          last_status = last_commit_statuses[0].state
        end
        unless last_status == "failure" or last_status == "success"
          if !pull.mergeable
            Derpsy.logger.info "merge conflict with master, failing"
            Derpsy::Notify.github_status(client, pull, "failure", "Merge conflict with master. Please pull upstream master, resolve conflicts, and recommit.")
            campfire_room.speak "Hey, #{pull.user.login}: :sob: Pull Request ##{pull.number} had a merge conflict with latest master. Please pull upstream master, resolve the conflicts, and re-push."
          #elsif pull.base.sha != last_master_commit
            #Derpsy.logger.info "PR is not based on latest master, failing"
            #Derpsy::Notify.github_status(client, pull, "failure", "Pull request is not based on latest master.")
            #campfire_room.speak "Hey, #{pull.user.login}: :unamused: Pull Request ##{pull.number} is not based on latest master, so cannot be tested. Please pull upstream master, verify the merge is good, and re-push."
          else
            Derpsy.logger.info "Found good pull request, setting status to 'pending'"
            Derpsy::Notify.github_status(client, pull, "pending", "Derpsy began testing this pull request at #{Time.now.strftime('%I:%M:%S%p')}.")
            return pull
          end
        end
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
