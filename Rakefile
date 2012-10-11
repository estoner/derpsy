require 'rake'
require 'rake/testtask'
require 'awesome_print'
require 'highline/import'

task :default => [:config]

desc "Configure Derpsy"
task :config do |t|
  say "Before you can start Derpsy, you must configure it to access GitHub and Campfire, and run your tests."
  login = ask "GitHub username?"
  github_token = ask "GitHub OAuth token?"
  repo = ask "GitHub repo (i.e. 'mojombo/jekyll'?"
  branch = ask "Branch to test against (usually 'master')?"
  bundler_options = ask "Options to pass to Bundler (i.e. '--without production')?"
  test_cmd = ask "Command to run tests (i.e. 'bundle exec cucumber')?"
  allowed_reruns = ask "Number of reruns allowed for failing tests?"
  working_directory = ask "Working directory (i.e. '/home/bob/derpsy-work')?"
  campfire_token = ask "Campfire OAuth token?"
  campfire_subdomain = ask "Campfire subdomain?"
  campfire_room_name = ask "Campfire room name?"
  config_template = <<-CONFIGEND
    module Derpsy
      def self.config
        {
          :login => "#{login}",
          :github_token => "#{github_token}",
          :repo => "#{repo}",
          :branch => "#{branch}",
          :bundler_options => "#{bundler_options}",
          :test_cmd => "#{test_cmd}",
          :allowed_reruns => "#{allowed_reruns}",
          :working_directory => "#{working_directory}",
          :campfire_token => "#{campfire_token}",
          :campfire_subdomain => "#{campfire_subdomain}",
          :campfire_room_name => "#{campfire_room_name}"
        }
      end
    end
  CONFIGEND
  say config_template
end

desc "Run all tests"
Rake::TestTask.new do |t|
  puts "Running Derpsy tests."
  puts "NOTE: If you have not done so already, copy config.rb.txt to config.rb and edit it."
  puts "NOTE-TO-SELF: Write a rake task that prompts for config values and writes the file."
  t.libs << "spec"
  t.test_files = FileList['spec/*_spec.rb']
end

desc "Regenerate fixtures"
task :fixtures do
  require File.expand_path('../lib/derpsy', __FILE__)
  require File.expand_path('../lib/derpsy/retrieve', __FILE__)
  pull_file = "spec/fixtures/pulls-fail.marshal"
  File.delete(pull_file)
  pull = Derpsy::Retrieve.pull_request(Derpsy.client, Derpsy.config[:repo])
  File.open(pull_file, "wb") {|file| Marshal.dump(pull, file)}
end

