require_relative 'array_logic'

rule_sets = [
  "(t1 and t2) or (t3 and t4)",
  "t1 and not t2",
  "2 in t1 t2 t3",
  "(2 in t1 t2 t3) and (1 in t4 t5)"
]

rule_sets.each do |rule_set|
  
  rule = ArrayLogic::Rule.new(rule_set)
  
  puts "----------------------------\n"
  puts "The rule '#{rule_set}' would match the following:"
  
  rule.matching_combinations.each{|c| puts "\t#{c.inspect}"}
  
  puts "\nAnd would not match"
  
  rule.blocking_combinations.each{|c| puts "\t#{c.inspect}"}
  
  puts "\n\n"
end

or_rule = (1..12).to_a.collect{|n| "t#{n}"}.join(" or ")

rule = ArrayLogic::Rule.new or_rule

require 'benchmark'

Benchmark.bm do |x|
  x.report(:matching_combinations) { rule.matching_combinations }
  x.report(:blocking_combinations) { rule.blocking_combinations}
end