# Basic object used in testing 

module ArrayLogic
  class Thing
    attr_accessor :id
    
    def initialize(number)
      @id = number
    end
    
    def self.make(number)
      (1..number).to_a.collect{|n| new(n)}
    end
  end
end
