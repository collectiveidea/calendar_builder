require 'core_ext/time'
require 'calendar_builder'
require 'active_record/event_finders'
require 'active_record/event_validations'

ActionView::Base.send :include, CollectiveIdea::CalendarBuilder
ActiveRecord::Base.send :include, CollectiveIdea::EventFinders
ActiveRecord::Base.send :include, CollectiveIdea::EventValidations
