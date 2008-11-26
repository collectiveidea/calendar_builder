module CalendarBuilder
  module ActiveRecord
    module Validations
    
      def self.included(base)
        base.extend(ClassMethods)
      end
    
      module ClassMethods
        # Validates date/time fields in chronological order.  
        def validates_chronological(*attr_names)
          options = {:allow_nil => true, :message => "is not in chronological order", :on => :save }
          options.update(attr_names.extract_options!).symbolize_keys
                
          send(validation_method(options[:on]), options) do |record|
            previous = record.send(attr_names.first)
            attr_names.each do |attr|
              value = record.send(attr)
              next if ((value.nil? || previous.nil?) && options[:allow_nil]) || (!value.nil? && !previous.nil? && value >= previous)
              record.errors.add(attr, options[:message])
            end
          end
        end
      end

    end
  end
end