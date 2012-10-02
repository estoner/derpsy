module Derpsy

  module Notify

    def self.build_message(results)
      Derpsy.logger.info "build the message"

      message = { :status => "success", :text => "All tests passed!" }

      if !results[:success]
        message[:status] = "failure"
        message[:text] = results[:output]
      end

      #   if no changes in features/*.feature update comments to complain no new tests
      #   in comment, mention time it took to run tests, # of reruns and which failed
      #   if more than 2 reruns, get snarky
      #   if hardcore, run simplecov and complain if not 100% coverage

      Derpsy.logger.info "message is: #{message.to_s}"

      return message
    end

    def self.github(pull, message, config, client)
      Derpsy.logger.info "post comment to GitHub"
      desc = ""
      if message[:status] == "failure"
        desc = "#{message[:text]}"
      end
      begin
        response = client.create_status(pull.short_repo, pull.hash, message[:status], options = { :description => desc.slice(0..139)})
      rescue StandardError => boom
        Derpsy.logger.info "EROR when attempting to notify github: #{boom}"
      end
      # check response to make sure it worked
      #   if failed, maybe close request?
    end

    def self.github_status(client, pull, status, description)
      hash = pull.head.sha
      short_repo = pull.head.repo.full_name
      begin
        response = client.create_status(short_repo, hash, status, options = { :description => description.slice(0..139)})
      rescue StandardError => boom
        Derpsy.logger.info "EROR when attempting to notify github: #{boom}"
      end
    end

    def self.campfire(pull, message, config, room)
      Derpsy.logger.info "send notification to Campfire"
      room.speak "Derpsy has analyzed #{pull.user}'s pull request '#{pull.title}'..."
      if message[:status] == "success"
        room.speak ":sparkles: :heart: It passes! :heart: :sparkles: Please code review and merge: #{pull.web_url.href}"
      elsif message[:status] == "failure"
        room.speak ":fire: :poop: It is borked! :poop: :fire: Failures on #{message[:text]}"
        room.speak "Please do not merge, unless you have determined conclusively that this is an environment issue: #{pull.web_url.href}"
      else
        room.speak "Whoops! Derpsy had some kind of internal derp of its own. Ask Evan to fix that."
      end
    end

  end

end
