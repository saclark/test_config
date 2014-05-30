require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'bundler/gem_tasks'

# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'nested']
end

# Run with `rake cucumber`
Cucumber::Rake::Task.new(:cucumber)

task :default => [:spec, :cucumber]
