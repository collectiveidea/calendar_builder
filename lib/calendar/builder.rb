module Calendar
  module Builder
    DAYNAME_SYMBOLS = Date::DAYNAMES.collect {|day| day.downcase.to_sym }

    def self.for(type)
      const_get(type.to_s.camelize)
    end
    
  end
end