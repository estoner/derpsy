module Derpsy

  module Notify

    def self.build_message(results)
      Derpsy.logger.info "build the message"
      #   if no changes in features/*.feature update comments to complain no new tests
      #   in comment, mention time it took to run tests, # of reruns and which failed
      #   if more than 2 reruns, get snarky
      #   if hardcore, run simplecov and complain if not 100% coverage
    end

    def self.comment(pull, message, config)
      Derpsy.logger.info "post comment to GitHub"
      #   if failed, close request
    end

    def self.campfire(pull, message, config)
      Derpsy.logger.info "send notification to Campfire"
    end

  end

end
