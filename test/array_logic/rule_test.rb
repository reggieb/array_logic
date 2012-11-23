require 'test/unit'
require_relative '../../lib/array_logic'

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
