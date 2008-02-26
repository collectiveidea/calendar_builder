$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rubygems'
require 'action_controller'
require 'action_view'
gem 'activerecord', '>= 1.99.1'
require 'active_record'

require File.dirname(__FILE__) + '/../init.rb'

require 'test/unit'
require 'mocha'
require 'action_controller/test_process'

require 'active_record/fixtures'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + "/db/database.yml"))
ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite3")
ActiveRecord::Migration.verbose = false
load(File.join(File.dirname(__FILE__), "db", "schema.rb"))

Dir["#{File.dirname(__FILE__)}/fixtures/*.rb"].each {|file| require file }


class Test::Unit::TestCase #:nodoc:
  self.fixture_path = File.dirname(__FILE__) + "/fixtures/"
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end