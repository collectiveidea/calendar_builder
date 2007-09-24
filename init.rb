# Include hook code here

require 'core_ext/time'
require 'calendar_builder'

ActionController::Base.send :include, CollectiveIdea::CalendarBuilder