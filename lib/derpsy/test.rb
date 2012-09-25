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
      Bundler.with_clean_env do
        Dir.chdir dir do
          #check = `RBENV_DIR="" rbenv exec bundle check`
          check = `bundle check`
          status = $?.to_i 
          puts "check:"
          ap check
          puts "status:"
          ap status
          if status == 0
            false
          else
            true
          end 
        end
      end
    end 

    def self.setup(pull, directory, upstream_repo, branch="master")
      repo_dir = directory + "/repo"
      FileUtils.mkdir_p repo_dir
      
      Dir.chdir repo_dir do

        if Derpsy::Test.is_valid_repo?
          `git reset --hard HEAD`
          `git checkout master`
          `git branch -D merge`
          `rm -rf deployed_app/`
          `git pull`
        else
          `git clone #{upstream_repo} .`
          # msg can pass an error
        end
        `git checkout -b merge`
        puts "pulling ssh url"
        puts "git pull #{pull.repo} #{branch}"
        `git pull #{pull.repo} #{branch}`
        # plenty of merge errors here

        if Derpsy::Test.needs_bundle_install? repo_dir
          Bundler.with_clean_env do
            # this is currently fucked
            puts "installing bundle"
            #`RBENV_DIR="" rbenv exec bundle install`
            `bundle install`
            # also, make the --without flag configurable
          end
          # should really check for errors here
        end

      end
      
    end

    def self.run(test_cmd, dir)
      dir = dir + "/repo"
      #Derpsy.logger.info "run the tests"
      # reruns.each do { [test cmd with no weird formatting] if pass then return "passed" }
      # if fail then return "failed"
      Bundler.with_clean_env do
        Dir.chdir dir do

          # for some reason the bundle exec isn't working, grrr
          #output = `RBENV_DIR="" rbenv exec #{test_cmd}`
          full_output = `#{test_cmd}`
          rerun = File.readlines('rerun.txt')[0]
          return { :status => $?.to_i, 
                   :output => rerun 
                 }
        end
      end
    end

    def self.interpret(data)
      Derpsy.logger.info "interpret the results"
      
      results = { :success => false, :output => data[:output] }

      # figure out what the F the test results mean
      Derpsy.logger.info "status was: #{data[:status]}"
      Derpsy.logger.info "output was: #{data[:output]}"

      if data[:status] == 0
        results[:success] = true
      end

      Derpsy.logger.info "results were: #{results[:status].to_s}"
      Derpsy.logger.info "output was: #{results[:output]}"

      # run other code metrics (simplecov, were there new tests, cane)
      return results
    end

    def self.cleanup(directory)
      repo_dir = directory + "/repo"
      # Derpsy.logger.info "clean up the repo"
      Dir.chdir repo_dir do
        `git checkout master`
        `git branch -D merge`
        `rm -rf deployed_app`
      end
    end

  end

end
