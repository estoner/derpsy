require 'rake'
require 'rake/testtask'
require 'awesome_print'

task :default => [:test]

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
