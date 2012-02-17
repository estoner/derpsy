module Derpsy

  module Test

    BUNDLER_VARS = %w(BUNDLE_GEMFILE RUBYOPT BUNDLE_BIN_PATH)

    def self.with_clean_env
      bundled_env = ENV.to_hash
      BUNDLER_VARS.each{ |var| ENV.delete(var) }
      yield
    ensure
      ENV.replace(bundled_env.to_hash)
    end
  
    def self.is_valid_repo?
      msg = IO.popen("git rev-parse --git-dir").readlines.first
      if msg == ".git\n"
        true
      else
        false
      end
    end


    def self.needs_bundle_install?(dir)
      with_clean_env do
        Dir.chdir dir do
          `bundle check`
          if $?.to_i == 0
            false
          else
            true
          end 
        end
      end
    end 

    def self.setup(pull, directory, upstream_repo)
      repo_dir = directory + "/repo"
      FileUtils.mkdir_p repo_dir
      Dir.chdir repo_dir

      if Derpsy::Test.is_valid_repo?
        `git pull`
      else
        `git clone #{upstream_repo} .`
        # msg can pass an error
      end

      `git checkout -b merge`
      `git pull #{pull.repo}`
      puts `git log --pretty=format:'%h' -n 1`
      # plenty of merge errors here

      if Derpsy::Test.needs_bundle_install? repo_dir
        with_clean_env do
          # this is currently fucked
          `bundle install --without compression`
          # also, make the --without flag configuratble
        end
        # should really check for errors here
      end
      
    end

    def self.run
      Derpsy.logger.info "run the tests"
      # reruns.each do { [test cmd with no weird formatting] if pass then return "passed" }
      # if fail then return "failed"
    end

    def self.interpret
      Derpsy.logger.info "interpret the results"
      # figure out what the F the test results mean
      # run other code metrics (simplecov, were there new tests, cane)
    end

    def self.cleanup
      # Derpsy.logger.info "clean up the repo"
      `git checkout master`
      `git branch -D merge`
    end

  end

end
