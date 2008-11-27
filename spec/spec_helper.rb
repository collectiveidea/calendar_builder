ENV["RAILS_ENV"] = "test"
$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rubygems'
require 'multi_rails_init'
require 'active_record'
require 'action_controller'
require 'action_view'
require File.dirname(__FILE__) + '/../init.rb'

require 'active_record/fixtures'
require 'action_controller/test_process'

require 'spec'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/db/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3mem'])

ActiveRecord::Migration.verbose = false
load(File.dirname(__FILE__) + "/db/schema.rb")

Spec::Runner.configure do |config|
  # config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = '/spec/fixtures/'
end

Dir[File.dirname(__FILE__) + '/shared/*.rb'].each {|s| require s }