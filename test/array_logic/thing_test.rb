require 'test/unit'
require_relative '../../lib/array_logic'

module ArrayLogic
  class ThingTest < Test::Unit::TestCase
    def test_make
      number = 10
      things = Thing.make(number)
      assert_equal(number, things.length)
      assert_equal((1..number).to_a, things.values.collect(&:id))
      assert_equal((1..number).to_a, things.keys)
    end
    
    def test_cost
      thing = Thing.new(1)
      assert_equal(2, thing.cost)
    end
    
    def test_id_odd
      things = Thing.make(4)
      assert_equal([true, nil, true, nil], things.values.collect(&:id_odd?))
    end
  end
end
