require 'core_ext/time'
require 'calendar_builder'
require 'active_record/event_finders'

ActionView::Base.send :include, CollectiveIdea::CalendarBuilder
ActiveRecord::Base.send :include, CollectiveIdea::EventFinders
