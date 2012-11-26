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
    
    def test_one_or_one_and
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
    
    def test_match_without_rule
      assert_raises RuntimeError do
        @rule.match([1, 2])
      end
    end
    
    def test_match_with_number_rule
      @rule.rule = 1
      assert_raises RuntimeError do
        @rule.match([1, 2])
      end
    end

    def test_replace_item
      @rule.rule = 't1 or ( t2 and t3 )'
      process = lambda {|s| [1, 2].include?(s[/\d+/].to_i)}
      result = @rule.replace_item(/\w\d+/, process)
      assert_equal('true or ( true and false )', result)
    end
    
  end
end
