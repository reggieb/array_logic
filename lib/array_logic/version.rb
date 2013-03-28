module ArrayLogic
  VERSION = "0.2.4"
end

# History
# =======
# 
# Version 0.2.4
# -------------
# Adds mechanism for handling issue of being unable to determine combinations
# for rules with functions, without increasing complexity of combinations methods.
# Choice of how to handle the issue can be made in the host app.
# 
# Version 0.2.3
# -------------
# Bug fix: Identification of ids in rule would see a number preceded by a number 
# as a valid id. So 51 would be seen as 1, and 34 as 4. Updated id pattern to 
# only return numbers that are preceded by a letter.
# 
# Version 0.2.2
# -------------
# Refactor to allow functions to be more flexible. That's is, to handle unexpected
# input, rather than just rejecting it.
# 
# Version 0.2.1
# -------------
# Improved handling of errors in functions and add != operator
# 
# Version 0.2.0
# -------------
# Adds functions: sum, count and average
# 
# Version 0.1.2
# -------------
# Refactor to tidy up code and make private, rule methods that don't need exposing
# 
# 
# Version 0.1.1
# -------------
# Working version. No history before this point
#
