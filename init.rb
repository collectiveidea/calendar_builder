require 'calendar_builder'

if defined?(ActiveRecord)
  require 'calendar_builder/active_record/finders'
  require 'calendar_builder/active_record/validations'
  ActiveRecord::Base.send :include, CalendarBuilder::ActiveRecord::Finders
  ActiveRecord::Base.send :include, CalendarBuilder::ActiveRecord::Validations
end

if defined?(ActionView)
  require 'calendar_builder/action_view/helper'
  ActionView::Base.send :include, CalendarBuilder::ActionView::Helper
end
