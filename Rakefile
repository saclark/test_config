require 'coveralls/rake/task'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'bundler/gem_tasks'

# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

# Run with `rake cucumber`
Cucumber::Rake::Task.new(:features)

# For Coveralls
Coveralls::RakeTask.new
task :test_with_coveralls => [:spec, :features, 'coveralls:push']

task :default => [:spec, :features]
