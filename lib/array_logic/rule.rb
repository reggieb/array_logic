module ArrayLogic
  class Rule
    attr_accessor :rule
    attr_reader :things, :thing_ids

    def initialize(rule = nil)
      @rule = rule
    end

    def matches(*array_of_things)
      array_of_things.delete_if{|things| block(things)}
    end
    
    def blockers(*array_of_things)
      array_of_things.delete_if{|things| match(things)}
    end

    def match(things)
      check_rule
      @things = things
      @thing_ids = things.collect(&:id)
      logic
    end
    
    def block(things)
      ! match(things)
    end

    def logic
      eval(expression)  
    end

    def rule_valid?
      check_rule
      !rule.empty?
    rescue
      return false
    end

    def replace_item(pattern, processor)
      @processed_rule = processed_rule.gsub(pattern) {|x| processor.call(x)}
    end
    
    def object_ids_used
      chrs_after_first = 1..-1
      @object_ids_used ||= objects_identifiers_in_rule.collect{|i| i[chrs_after_first].to_i}.uniq
    end
    
    def matching_combinations
      combinations_of_identifiers_in_rule_that_pass {|c| match_ids(c)}  
    end
    
    def blocking_combinations
      combinations_of_identifiers_in_rule_that_pass {|c| ! match_ids(c)}
    end
    
    def check_rule
      check_rule_entered
      check_allowed_characters
    end
    
    private
    def match_ids(ids)
      @thing_ids = ids
      logic
    end
    
    def combinations_of_identifiers_in_rule_that_pass(&test)
      if rule_valid?
        combinations = Array.new
        (1..id_count).each{|n| object_ids_used.combination(n).each{|c| combinations << c if test.call(c)}}
        return combinations  
      end
    end
    
    def id_count
      object_ids_used.length
    end
        
    def objects_identifiers_in_rule
      rule_without_punctuation.split.delete_if{|x| !(thing_id_pattern =~ x)}
    end
    
    def expression
      rule_processing_steps
      return final_processed_rule
    end

    def rule_processing_steps
      add_space_around_puctuation_characters
      make_everything_lower_case
      replace_logic_words_with_operators
      replace_item(thing_id_pattern, true_or_false_for_thing_id_in_thing_ids)
      replace_item(number_in_set_pattern, comparison_of_number_with_true_count)
    end

    # for example: 2 in t1, t2, t3
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
      @processed_rule = processed_rule.gsub(/(\)|\)|\,)/, ' \1 ')
    end

    def make_everything_lower_case
      @processed_rule = processed_rule.downcase
    end

    def replace_logic_words_with_operators
      {
        'and' => '&&',
        'or' => '||',
        'not' => '!'
      }.each{|word, operator| @processed_rule = processed_rule.gsub(Regexp.new(word), operator)}
    end  

    def final_processed_rule
      result = processed_rule.clone
      reset_processed_rule_ready_for_next_comparison
      return result
    end

    def reset_processed_rule_ready_for_next_comparison
      @processed_rule = nil
    end
    
    def rule_without_punctuation
      rule.gsub(/[[:punct:]]/, '')
    end

    def check_rule_entered
      raise "You must define a rule before trying to match" unless rule.kind_of? String
    end

    def check_allowed_characters
      raise_invalid_characters unless allowed_characters_pattern =~ rule
    end
    
    def raise_invalid_characters
      invalid = rule.split.collect{|s| (allowed_characters_pattern =~ s) ? nil : s }.compact
      raise "The rule '#{rule}' is not valid. The problem is within '#{invalid.join(' ')}'"
    end    

    def allowed_characters_pattern
      case_insensitive = true
      Regexp.new("^(#{array_of_allowed_patterns.join('|')})*$", case_insensitive)
    end

    def allowed_characters
      {
        :brackets => ['\(', '\)'],
        :in_pattern => ['\d+\s+in'],
        :ids => ['\w\d+'],
        :logic_words => %w{and or not},
        :logic_chrs => ['&&', '\|\|', '!'],
        :commas => ['\,'],
        :white_space => ['\s'],
      }
    end
    
    def array_of_allowed_patterns
      allowed_characters.values.flatten
    end

  end
end
