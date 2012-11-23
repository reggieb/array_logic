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
  end
end
