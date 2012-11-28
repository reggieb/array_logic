module ArrayLogic
  class Rule
    attr_accessor :rule
    attr_reader :things, :thing_ids

    def initialize

    end

    def matches(*array_of_things)
      array_of_things.delete_if{|things| !match(things)}
    end

    def match(things)
      rule_valid?
      @things = things
      @thing_ids = things.collect(&:id)
      logic
    end

    def logic
      eval(expression)  
    end

    def rule_valid?
      check_rule_entered
      check_allowed_characters
    end

    def replace_item(pattern, processor)
      @processed_rule = processed_rule.gsub(pattern) {|x| processor.call(x)}
    end
    
    def object_ids_used
      chrs_after_first = 1..-1
      objects_identifiers_in_rule.collect{|i| i[chrs_after_first].to_i}
    end
    
    def combinations_that_match
      combinations_of_identifiers_in_rule.delete_if{|ids| ! match_ids(ids)} if rule and !rule.empty?
    end
    
    def combinations_that_do_not_match
      combinations_of_identifiers_in_rule.delete_if{|ids| match_ids(ids)} if rule and !rule.empty?
    end

    private
    def match_ids(ids)
      rule_valid?
      @thing_ids = ids
      logic
    end
    
    def combinations_of_identifiers_in_rule
      ids = object_ids_used
      combinations = Array.new
      (1..ids.length).each{|n| ids.combination(n).each{|c| combinations << c}}
      return combinations
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
      raise_invalid_charachers unless allowed_charachers_pattern =~ rule
    end

    def allowed_charachers_pattern
      case_insensitive = true
      Regexp.new("^(#{allowed_characters.join('|')})*$", case_insensitive)
    end

    def allowed_characters
      brackets = ['\(', '\)']
      in_pattern = ['\d+\s+in']
      ids = ['\w\d+']
      logic_words = %w{and or not}
      logic_chrs = ['&&', '\|\|', '!']
      commas = ['\,']
      white_space = ['\s']

      [brackets, in_pattern, ids, logic_words, logic_chrs, commas, white_space].flatten
    end

    def raise_invalid_charachers
      invalid = rule.split.collect{|s| (allowed_charachers_pattern =~ s) ? nil : s }.compact
      raise "The rule '#{rule}' is not valid. The problem is within '#{invalid.join(' ')}'"
    end

  end
end
