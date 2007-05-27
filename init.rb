# Include hook code here

require 'core_ext/time'
require 'calendar_builder'

ActionView::Base.send :include, CollectiveIdea::CalendarBuilder