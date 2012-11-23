
class Rule
  attr_accessor :rule
  attr_reader :things
  
  def initialize
    
  end
  
  def match(things)
    check_rule
    @things = things
    logic
  end
  
  def logic
    eval(expression)  
  end
  
  def rule_valid?
    rule.kind_of? String
  end
  
  private
  def thing_ids
    things.collect(&:id)
  end
  
  def rule_components
    rule.split
  end
  
  def rule_components_with_things
    rule_components.collect{|c| c =~ /^\w\d+$/ ? c[/\d+/].to_i : c }
  end
  
  def rule_components_as_logic_elements
    rule_components_with_things.collect do |component|
      if component.kind_of?(Integer)
        thing_ids.include?(component).to_s
      elsif component == 'and'
        '&&'
      elsif component == 'or'
        '||'
      else
        component
      end 
    end
  end
  
  def expression
    rule_components_as_logic_elements.join(' ')
  end
  
  
  def check_rule
    raise "You must define a rule before trying to match" unless rule_valid?
  end
  
end
