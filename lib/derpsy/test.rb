module Derpsy

  module Test

    BUNDLER_VARS = %w(BUNDLE_GEMFILE RUBYOPT BUNDLE_BIN_PATH)

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
          if status == 0
            false
          else
            true
          end 
        end
      end
    end 

    def self.setup(pull, directory, upstream, branch, token, bundler_options)

      Derpsy.logger.info "setting up local repo to test pull # #{pull.id}"

      pull_repo = pull.repo.gsub(/:\/\//, "://#{token}@")
      upstream_repo = upstream.gsub(/:\/\//, "://#{token}@")

      repo_dir = directory + "/repo"
      FileUtils.mkdir_p repo_dir

      Dir.chdir repo_dir do

        if Derpsy::Test.is_valid_repo?
          `git reset --hard HEAD`
          `git checkout master`
          `git branch -D merge`
          `rm -rf deployed_app/`
          `rm rerun.txt`
          Derpsy.logger.info "pulling #{upstream_repo} onto master"
          `git pull #{upstream_repo}`
        else
          `git init .`
          Derpsy.logger.info "pulling #{upstream_repo} onto initialized repo"
          `git pull #{upstream_repo}`
          # msg can pass an error
        end
        `git checkout -b merge`
        Derpsy.logger.info "pulling #{pull_repo} #{pull.branch} onto master"
        `git pull #{pull_repo} #{pull.branch}`
        # plenty of merge errors here

        if Derpsy::Test.needs_bundle_install? repo_dir
          Bundler.with_clean_env do
            # this is currently fucked
            #`RBENV_DIR="" rbenv exec bundle install`
            `bundle install #{bundler_options}`
          end
          # should really check for errors here
        end

      end

    end

    def self.run(test_cmd, dir, allowed_reruns)
      dir = dir + "/repo"

      # consider setting status of pull to "pending"
      # Octokit::Client::Status.create_status(pull.repo, pull.hash, "pending", options = { :description => "Derpsy is reviewing your change for derps."})

      Derpsy.logger.info "running tests"
      # reruns.each do { [test cmd with no weird formatting] if pass then return "passed" }
      # if fail then return "failed"
      Bundler.with_clean_env do
        Dir.chdir dir do

          # for some reason the bundle exec isn't working, grrr
          #output = `RBENV_DIR="" rbenv exec #{test_cmd}`
          full_output = `#{test_cmd}`
          #full_output = `ruby /Users/estoner/pixies-derpsy/fail.rb`
          #full_output = `ruby /Users/estoner/pixies-derpsy/pass.rb`
          status = $?.to_i
          allowed_reruns.times do |i|
            if status != 0
              rerun = File.readlines('deployed_app/rerun.txt')[0]
              Derpsy.logger.info "tests failed on #{rerun}"
              Derpsy.logger.info "performing rerun ##{i}"
              full_output = `#{test_cmd}`
              status = $?.to_i
            end
          end
          if status != 0
            message = File.readlines('deployed_app/rerun.txt')[0]
            Derpsy.logger.info "tests failed on final rerun: #{message}"
          else
            message = ""
          end
          return { :status => status,
                   :output => message
                 }
        end
      end
    end

    def self.interpret(data)
      Derpsy.logger.info "interpreting results"

      results = { :success => false, :output => data[:output] }

      # figure out what the F the test results mean
      Derpsy.logger.info "status was: #{data[:status]}"
      Derpsy.logger.info "output was: #{data[:output]}"

      if data[:status] == 0
        results[:success] = true
      end

      Derpsy.logger.info "results were: #{results[:success].to_s}"
      Derpsy.logger.info "output was: #{results[:output]}"

      # run other code metrics (simplecov, were there new tests, cane)
      return results
    end

    def self.cleanup(directory)
      repo_dir = directory + "/repo"
      # Derpsy.logger.info "cleaning local repo"
      Dir.chdir repo_dir do
        `git reset --hard HEAD`
        `git checkout master`
        `git branch -D merge`
        `rm -rf deployed_app`
      end
    end

  end

end
