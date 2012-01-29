require 'rake'
require 'rake/testtask'
require 'awesome_print'

task :default => [:test]

desc "Run all tests"
Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/*_spec.rb']
end

desc "Regenerate fixtures"
task :fixtures do
  require_relative 'lib/derpsy'
  require_relative 'lib/derpsy/retrieve'
  filename = "spec/fixtures/pulls.marshal"
  File.delete(filename)
  pulls = Derpsy::Retrieve.pull_requests
  ap pulls
  File.open(filename, "wb") {|file| Marshal.dump(pulls, file)}
end
