
class Rule
  attr_accessor :rule
  attr_reader :things
  
  def initialize
    
  end
  
  def match(things)
    check_rule
    @things = things
    result = logic
  end
  
  def logic
    eval(expression)  
  end
  
  def rule_valid?
    rule.kind_of? String
  end
  
  def replace_item(pattern, processor)
    @processed_rule = processed_rule.gsub(pattern) {|x| processor.call(x)}
  end
  
  private
  def thing_ids
    things.collect(&:id)
  end
  
  def expression
    
    add_space_around_puctuation_characters
    
    replace_item(thing_id_pattern, true_or_false_for_thing_id_in_thing_ids)

    final_processed_rule
    
  end
  
  # examples: a1, a2, a33, t1
  def thing_id_pattern
    /\w\d+/
  end
  
  def true_or_false_for_thing_id_in_thing_ids
    lambda {|s| thing_ids.include?(s[/\d+/].to_i)}
  end
  
  def processed_rule
    @processed_rule ||= rule.clone
  end

  def add_space_around_puctuation_characters
    @processed_rule = processed_rule.gsub(/([[:punct:]])/, ' \1 ')
  end
  
  def final_processed_rule
    result = processed_rule.clone
    reset_processed_rule_ready_for_next_comparison
    return result
  end
  
  def reset_processed_rule_ready_for_next_comparison
    @processed_rule = nil
  end
  
  def check_rule
    raise "You must define a rule before trying to match" unless rule_valid?
  end
  
end
