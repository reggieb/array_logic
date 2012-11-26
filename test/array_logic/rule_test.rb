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
    
  end
end
