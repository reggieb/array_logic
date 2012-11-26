
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
  
  def replace_item(pattern, processor)
    @processed_rule = processed_rule.gsub(pattern) {|x| processor.call(x)}
  end
  
  private
  def thing_ids
    things.collect(&:id)
  end
  
  def expression
    prepare_rule
    rule_processing_steps
    return final_processed_rule
  end
  
  def prepare_rule
    add_space_around_puctuation_characters
  end
  
  def rule_processing_steps
    replace_item(thing_id_pattern, true_or_false_for_thing_id_in_thing_ids)
    replace_item(number_in_set_pattern, comparison_of_number_with_true_count)
  end
  
  def number_in_set_pattern
    /\d+\s+in\s+((true|false)[\,\s]*)+/
  end
  
  def comparison_of_number_with_true_count
    lambda do |string|
      before_in, after_in = string.split(/\s+in\s+/)
      true_count = after_in.split.count('true')
      " ( #{before_in} <= #{true_count} ) "
    end
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
    puts result = processed_rule.clone
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
