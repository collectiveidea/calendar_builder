require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require "load_multi_rails_rake_tasks" rescue LoadError nil

desc 'Default: run specs.'
task :default => :spec

desc 'Test the acts_as_audited plugin'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

desc 'Generate documentation for the calendar_builder plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'CalendarBuilder'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'test/javascripttest'
desc "Runs all the JavaScript unit tests and collects the results"
JavaScriptTestTask.new(:unittest) do |t|
  t.mount("/assets")
  t.mount("/test/javascript")
  
  # t.run("/test/javascript/calendar_test.html")
  t.run("/test/javascript/iso8601_test.html")
  
  t.browser(:safari)
  # t.browser(:firefox)
  # t.browser(:ie)
  # t.browser(:konqueror)
end