from generate1 import *

# Generate M files for binary operations

fname = "plus.m"	# Name of output file
opname = "plus"
comment = """% QO/PLUS adds together quantum array objects
% q = plus(q1,q2) adds together q1 and q2"""
operand = "+"
generate1(fname,opname,operand,comment)

#

fname = "minus.m"	# Name of output file
opname = "minus"
comment = """% QO/MINUS subtracts quantum array objects
% q = minus(q1,q2) subtracts q2 from q1"""
operand = "-"
generate1(fname,opname,operand,comment)

#

fname = "times.m"	# Name of output file
opname = "times"
comment = """% QO/TIMES multiplies quantum array objects elementwise
% q = times(q1,q2) computes q1 times q2 elementwise"""
operand = ".*"
generate1(fname,opname,operand,comment)

#

fname = "ldivide.m"	# Name of output file
opname = "ldivide"
comment = """% QO/LDIVIDE computes left division of quantum array objects elementwise
% q = ldivide(q1,q2) computes q1 left divide q2 elementwise"""
operand = ".\\"
generate1(fname,opname,operand,comment)

#

fname = "rdivide.m"	# Name of output file
opname = "rdivide"
comment = """% QO/RDIVIDE computes right division of quantum array objects elementwise
% q = rdivide(q1,q2) computes q1 right divide q2 elementwise"""
operand = "./"
generate1(fname,opname,operand,comment)

#

fname = "power.m"	# Name of output file
opname = "power"
comment = """% QO/POWER exponentiates quantum array objects elementwise
% q = power(q1,q2) raises q1 to power q2"""
operand = ".^"
generate1(fname,opname,operand,comment)

