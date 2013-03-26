module ArrayLogic
  
  # Basic object used in testing 
  class Thing
    attr_accessor :id
    
    def initialize(number)
      @id = number
    end
    
    def cost
      2
    end
    
    def id_odd
      return true if id % 2 != 0
    end
    
    def self.make(number)
      things = Hash.new
      (1..number).each{|n| things[n] = new(n)}
      return things
    end
  end
end
