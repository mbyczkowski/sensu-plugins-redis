require 'bundler/gem_tasks'
require 'github/markup'
require 'redcarpet'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'kitchen/rake_tasks'

YARD::Rake::YardocTask.new do |t|
  OTHER_PATHS = %w().freeze
  t.files = ['lib/**/*.rb', 'bin/**/*.rb', OTHER_PATHS]
  t.options = %w(--markup-provider=redcarpet --markup=markdown --main=README.md --files CHANGELOG.md)
end

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec) do |r|
  r.pattern = FileList['**/**/*_spec.rb']
end

desc 'Make all plugins executable'
task :make_bin_executable do
  `chmod -R +x bin/*`
end

desc 'Test for binstubs'
task :check_binstubs do
  bin_list = Gem::Specification.load('sensu-plugins-redis.gemspec').executables
  bin_list.each do |b|
    `which #{ b }`
    unless $CHILD_STATUS.success?
      puts "#{b} was not a binstub"
      exit
    end
  end
end

desc 'Run unit tests only'
RSpec::Core::RakeTask.new(:unit) do |r|
  r.pattern = FileList['**/**/*_spec.rb'].exclude(/test\/integration\//)
end

Kitchen::RakeTasks.new

desc 'Alias for kitchen:all'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.yml')
  config = Kitchen::Config.new(loader: @loader)
  threads = []
  config.instances.each do |instance|
    threads << Thread.new do
      instance.test(:always)
    end
  end
  threads.map(&:join)
end

task default: %i(make_bin_executable yard rubocop check_binstubs integration)

task quick: %i(make_bin_executable yard rubocop check_binstubs unit)
