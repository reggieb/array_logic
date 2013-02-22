require 'test/unit'
require_relative '../../lib/array_logic'
require_relative 'test_case'

module ArrayLogic
  class RuleTest < TestCase
    
    def setup
      @rule = Rule.new
    end
    
    def test_simple_and
      @rule.rule = 't1 and t2'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_no_thing_match([2, 3], @rule)
      assert_no_thing_match([3], @rule)
    end
    
    def test_simple_or
      @rule.rule = 't1 or t2'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([2, 3], @rule)
      assert_no_thing_match([3], @rule)      
    end
    
    def test_multiple_and
      @rule.rule = 't1 and t2 and t3'
      assert_no_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_no_thing_match([2, 3], @rule)
      assert_no_thing_match([3], @rule)
    end
    
    def test_multiple_or
      @rule.rule = 't1 or t2 or t3'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([3], @rule)
      assert_no_thing_match([4], @rule)
    end
    
    def test_one_or_one_and
      @rule.rule = 't1 or ( t2 and t3 )'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([2, 3], @rule)
      assert_no_thing_match([3], @rule)      
    end
    
    def test_one_or_one_and_version_two
      @rule.rule = '( t1 or t2 ) and t3'
      assert_no_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([2, 3], @rule)
      assert_no_thing_match([3], @rule)      
    end

    def test_one_or_one_and_not
      @rule.rule = 't1 or ( t2 and not t3 )'
      assert_thing_match([1, 3], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_no_thing_match([2, 3], @rule)
      assert_thing_match([2], @rule) 
      assert_thing_match([2, 4], @rule) 
    end 
    
    def test_one_or_one_and_with_no_space_between_tn_and_bracket
      @rule.rule = 't1 or (t2 and t3)'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([2, 3], @rule)
      assert_no_thing_match([3], @rule)      
    end
    
    def test_one_in_three
      @rule.rule = '1 in t1, t2, t3'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([3], @rule)
      assert_no_thing_match([4], @rule)       
    end
    
    def test_one_in_three_no_commas
      @rule.rule = '1 in t1 t2 t3'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([3], @rule)
      assert_no_thing_match([4], @rule)       
    end
    
    def test_one_in_three_with_and
      @rule.rule = '(1 in t1, t2, t3) and t3'
      assert_no_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([3], @rule)
      assert_no_thing_match([4], @rule)       
    end  
    
    def test_one_in_three_with_and_without_brackets
      @rule.rule = '1 in t1, t2, t3 and t3'
      assert_no_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([3], @rule)
      assert_no_thing_match([4], @rule)       
    end 

    def test_one_in_three_with_and_without_brackets_and_commas
      @rule.rule = '1 in t1 t2 t3 and t3'
      assert_no_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([3], @rule)
      assert_no_thing_match([4], @rule)       
    end
    
    def test_2_in_with_and_at_start
      @rule.rule = 't1 and t2 and 2 in t2 t3 t4'
      assert_no_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_thing_match([1, 2, 4], @rule)
      assert_no_thing_match([2, 3, 4], @rule)        
    end
    
    def test_in_within_logic_string
      @rule.rule = '(t1 and 1 in t2 t3) or t4'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_no_thing_match([3], @rule)
      assert_thing_match([4], @rule) 
    end
    
    def test_uppercase_in_within_logic_string
      @rule.rule = '(t1 AND 1 IN t2 t3) OR t4'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_no_thing_match([3], @rule)
      assert_thing_match([4], @rule) 
    end
    
    def test_operators_in_within_logic_string
      @rule.rule = '(t1 && 1 in t2 t3) || t4'
      assert_thing_match([1, 2], @rule)
      assert_thing_match([1, 2, 3], @rule)
      assert_no_thing_match([3], @rule)
      assert_thing_match([4], @rule) 
    end    
    
    def test_match_without_rule
      assert_raise RuntimeError do
        @rule.match([1, 2])
      end
    end
    
    def test_match_with_number_rule
      @rule.rule = 1
      assert_raise RuntimeError do
        @rule.match([1, 2])
      end
    end
    
    def test_match_with_empty_rule
      @rule.rule = ""
      things = get_things([1, 2])
      assert(!@rule.match([things.first]), "Should be no match when rule empty")
    end
    
    def test_block_without_rule
      assert_raise RuntimeError do
        @rule.block([1, 2])
      end
    end
    
    def test_block_with_number_rule
      @rule.rule = 1
      assert_raise RuntimeError do
        @rule.block([1, 2])
      end
    end
    
    def test_block_with_empty_rule
      @rule.rule = ""
      things = get_things([1, 2])
      assert(@rule.block([things.first]), "Should be block when rule empty")
    end    

    def test_replace_item
      @rule.rule = 't1 or ( t2 and t3 )'
      process = lambda {|s| [1, 2].include?(s[/\d+/].to_i)}
      result = @rule.send(:replace_item, /\w\d+/, process)
      assert_equal('true or ( true and false )', result)
    end
    
    def test_invalid_input
      @rule.rule = 'invalid'
      assert_raise RuntimeError do
        @rule.match([1])
      end
    end
    
    def test_another_invalid_input
      @rule.rule = 'a1 and User.delete_all'
      assert_raise RuntimeError do
        @rule.match([1])
      end
    end
    
    def test_matches_and_blokers
      @rule.rule = 't1 and t2'
      match_one = get_things [1, 2]
      match_two = get_things [1, 2, 3]
      no_match_one = get_things [2, 3]
      no_match_two = get_things [3]
      
      matches = @rule.matches(match_one, match_two, no_match_one, no_match_two)
      expected_matches = [match_one, match_two]   
      assert_equal(expected_matches, matches, "Matches should be returned")
      
      blockers = @rule.blockers(match_one, match_two, no_match_one, no_match_two)
      expected_blockers = [no_match_one, no_match_two]
      assert_equal(expected_blockers, blockers, "Blockers should be returned")
    end
    
    def test_matches_and_blokers_with_or
      @rule.rule = 't1 or t2'
      match_one = get_things [1, 2]
      match_two = get_things [1, 2, 3]
      match_three = get_things [2, 3]
      no_match_one = get_things [3]
      
      matches = @rule.matches(match_one, match_two, match_three, no_match_one)
      expected_matches = [match_one, match_two, match_three]
      assert_equal(expected_matches, matches, "Matches should be returned")
      
      blockers = @rule.blockers(match_one, match_two, match_three, no_match_one)
      expected_blockers = [no_match_one]
      assert_equal(expected_blockers, blockers, "Blockers should be returned")
    end
    
    def test_matches_with_empty_rule
      @rule.rule = ""
      things = get_things([1, 2]).collect{|t| [t]}
      assert_equal([], @rule.matches(*things))
    end
    
    def test_blokers_with_empty_rule
      @rule.rule = ""
      things = get_things([1, 2]).collect{|t| [t]}
      assert_equal(things, @rule.blockers(*things))
    end
    
    def test_object_ids_used
      @rule.rule = '(t1 && 1 in t2 t3) || t4'
      assert_equal([1, 2, 3, 4], @rule.object_ids_used)
    end
    
    def test_object_ids_user_does_not_return_duplicates
      @rule.rule = 't1 and t2 and (2 in t1 t2)'
      assert_equal([1, 2], @rule.object_ids_used)
    end
    
    def test_matching_combinations
      @rule.rule = 't1 or t2'
      assert_equal([[1], [2], [1,2]], @rule.matching_combinations)
      @rule.rule = 't1 and t2'
      assert_equal([[1,2]], @rule.matching_combinations)
    end
    
    def test_matching_combinations_without_rule
      @rule.rule = nil
      assert_equal(nil, @rule.matching_combinations)
      @rule.rule = ""
      assert_equal(nil, @rule.matching_combinations)
    end
    
    def test_matching_combinations_with_duplicate_ids
      @rule.rule = 't1 and t2 and (2 in t1 t2)'
      assert_equal(1, @rule.matching_combinations.length, "should not identify combinations for both occurancies of each id")
    end
    
    def test_blocking_combinations
      @rule.rule = 't1 or t2'
      assert_equal([], @rule.blocking_combinations)
      @rule.rule = 't1 and t2'
      assert_equal([[1],[2]], @rule.blocking_combinations)
    end
    
    def test_blocking_combinations_without_rule
      @rule.rule = nil
      assert_equal(nil, @rule.blocking_combinations)
      @rule.rule = ""
      assert_equal(nil, @rule.blocking_combinations)      
    end
    
    def test_blocking_combinations_when_none_returned
      @rule.rule = 't1'
      assert_equal([], @rule.blocking_combinations)
    end
    
    def test_assigning_rule_on_creation
      text = 'a1 and a2'
      rule = Rule.new(text)
      assert_equal(text, rule.rule)
    end
      
  end
end
