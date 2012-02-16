require "grit"
require "fileutils"

module Derpsy

  module Test
  
    def self.needs_bundle_install?
      msg = IO.popen("bundle check").readlines.first
      if msg == "The Gemfile's dependencies are satisfied\n"
        false
      else
        true
      end 
    end 

    def self.setup(pull, directory, upstream)
      repo_dir = directory + "/repo"
      puts repo_dir
      FileUtils.mkdir_p repo_dir
      Dir.chdir repo_dir
      
      begin
        repo = Grit::Repo.new(repo_dir)
      rescue Grit::InvalidGitRepositoryError
        puts "clone the repo"
        repo = Grit::Git.new(repo_dir)
        repo.clone({:quiet => false, :verbose => true, :progress => true, :branch => 'master'}, upstream, repo_dir)
      end

      if Derpsy::Test.needs_bundle_install?
        puts "needs bundle install"
        # IO.popen("bundle install")
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
    end

    def self.cleanup
      Derpsy.logger.info "clean up the repo"
      # git checkout master
      # git branch -D derp
    end

  end

end
