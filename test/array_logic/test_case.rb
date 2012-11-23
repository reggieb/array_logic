require 'test/unit'
require_relative '../../lib/array_logic'

module ArrayLogic
  class TestCase < Test::Unit::TestCase
    
    def self.things
      @things ||= Thing.make(10)
    end
    
    def get_things(thing_ids)
      @things = thing_ids.collect{|id| self.class.things[id]}
    end
    
    def assert_thing_match(thing_ids, rule)
      get_things(thing_ids)
      assert(rule.match(@things), "#{thing_ids.inspect} should match '#{rule.rule}'")
    end
    
    def assert_no_thing_match(thing_ids, rule)
      get_things(thing_ids)
      assert(!rule.match(@things), "#{thing_ids.inspect} should not match '#{rule.rule}'")
    end
  end
end
