
module Derpsy

  module Test
  
    def self.is_valid_repo?
      msg = IO.popen("git rev-parse --git-dir").readlines.first
      if msg == ".git\n"
        true
      else
        false
      end
    end


    def self.needs_bundle_install?(dir)
      puts "check the mother fucking bundle"
      puts dir
      Dir.chdir dir
      puts "pwd: " + Dir.pwd
      msg = IO.popen("bundle check").readlines.first
      puts msg
      if msg == "The Gemfile's dependencies are satisfied\n"
        puts "twas false"
        false
      else
        puts "twas true"
        true
      end 
    end 

    def self.setup(pull, directory, upstream_repo)
      repo_dir = directory + "/repo"
      FileUtils.mkdir_p repo_dir
      Dir.chdir repo_dir

      if Derpsy::Test.is_valid_repo?
        #   if repo, fetch and reset to hash
      else
        msg = IO.popen("git clone #{upstream_repo} .").readlines.first
        # msg can pass an error
      end

      msg = IO.popen("cd #{repo_dir}; pwd").readlines.to_s
      puts "FUCK" + msg
#      if Derpsy::Test.needs_bundle_install? repo_dir
#        puts "needs bundle install"
#        IO.popen("bundle install")
#        # should really check for errors here
#      end
      
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
