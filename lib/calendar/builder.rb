module Calendar
  module Builder
    
    def self.for(type)
      const_get(type.to_s.camelize)
    end
    
  end
end