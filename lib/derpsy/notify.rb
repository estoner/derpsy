module Derpsy

  module Notify

    def self.build_message(results)
      Derpsy.logger.info "build the message"

      message = { :success => results[:success], :text => "All tests passed!" }

      if !results[:success]
        message[:text] = "DERP!!1! This is borked! Tests which failed: \n  #{results[:output]}"
      end

      #   if no changes in features/*.feature update comments to complain no new tests
      #   in comment, mention time it took to run tests, # of reruns and which failed
      #   if more than 2 reruns, get snarky
      #   if hardcore, run simplecov and complain if not 100% coverage
      return message
    end

    def self.github(pull, message, config)
      Derpsy.logger.info "post comment to GitHub"
      #   if failed, close request
    end

    def self.campfire(pull, message, config)
      Derpsy.logger.info "send notification to Campfire"
    end

  end

end
