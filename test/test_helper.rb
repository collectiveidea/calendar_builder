$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rubygems'
require 'action_controller'
require 'action_view'

require File.dirname(__FILE__) + '/../init.rb'

require 'test/unit'
require 'mocha'
require 'action_controller/test_process'

