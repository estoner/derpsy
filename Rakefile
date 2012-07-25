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
  pull_file = "spec/fixtures/pulls-fail.marshal"
  File.delete(pull_file)
  pull = Derpsy::Retrieve.pull_request(Derpsy.client, Derpsy.config[:repo])
  ap pull
  File.open(pull_file, "wb") {|file| Marshal.dump(pull, file)}
end
