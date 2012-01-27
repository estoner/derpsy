module Derpsy

  module Test
  
    def self.setup
      Derpsy.logger.info "bundle install"
      # bundle install
    end

    def self.run
      Derpsy.logger.info "run the tests"
      # reruns.each do { [test cmd with no weird formatting] if pass then return "passed" }
      # if fail then return "failed"
    end

    def self.interpret
      Derpsy.logger.info "interpret the results"
      # figure out what the F the test results mean
    end

    def self.cleanup
      Derpsy.logger.info "clean up the repo"
      # git checkout master
      # git branch -D derp
    end

  end

end
