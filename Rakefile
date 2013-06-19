require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask::new(:spec)

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ['--private', '--embed-mixins', '--title "Fruit - Framework for UI Testing"']
end

task :default => [:spec, :yard, :build, :push]

desc 'Push the current version of the gem to the MI QA gem server'
task :push do
  path  = 'pkg/escenic-api-' + Escenic::API::VERSION + '.gem'
  host  = 'http://rutl217t.nandomedia.com:9292'
  begin
    `gem inabox '#{path}' --host #{host}`
  end
  puts $?.success? ? "\nGem successfully pushed to gem server at #{host}\n" : nil
end