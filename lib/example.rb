require_relative 'array_logic'

rule_sets = [
  "(t1 and t2) or (t3 and t4)",
  "t1 and not t2",
  "2 in t1 t2 t3",
  "(2 in t1 t2 t3) and (1 in t4 t5)"
]

rule_sets.each do |rule_set|
  
  rule = ArrayLogic::Rule.new
  rule.rule = rule_set
  
  puts "----------------------------\n"
  puts "The rule '#{rule_set}' would match the following:"
  
  rule.combinations_that_match.each{|c| puts "\t#{c.inspect}"}
  
  puts "\nAnd would not match"
  
  rule.combinations_that_do_not_match.each{|c| puts "\t#{c.inspect}"}
  
  puts "\n\n"
end
