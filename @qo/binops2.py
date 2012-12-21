from generate2 import *

# Generate M files for matrix binary operations

fname = "mtimes.m"	# Name of output file
opname = "mtimes"
comment = """% QO/MTIMES matrix multiplies quantum array objects
% q = mtimes(q1,q2) multiplies together q1 and q2"""
operand = "*"
operandf = operand + " ("
super = ""
matmat = ""
matscalar = ""
scalarmat = ""
generate2(fname,opname,operand,operandf,comment,super,matmat,matscalar,scalarmat)

#
fname = "mrdivide.m"	# Name of output file
opname = "mrdivide"
comment = """% QO/MRDIVIDE performs matrix right division on quantum array objects
% q = mrdivide(q1,q2) performs matrix right division on q1 and q2"""
operand = "/"
operandf = operand + " ("
super = "error('Cannot right divide superoperator by an operator');"
matmat = ""
matscalar = ""
scalarmat = ""
generate2(fname,opname,operand,operandf,comment,super,matmat,matscalar,scalarmat)

#

fname = "mldivide.m"	# Name of output file
opname = "mldivide"
comment = """% QO/MLDIVIDE performs matrix left division on quantum array objects
% q = mldivide(q1,q2) performs matrix left division on q1 and q2"""
operand = "\\"
operandf = operand + " ("
super = ""
matmat = ""
matscalar = ""
scalarmat = ""
generate2(fname,opname,operand,operandf,comment,super,matmat,matscalar,scalarmat)

#

fname = "mpower.m"	# Name of output file
opname = "mpower"
comment = """% QO/MPOWER performs matrix exponentiation quantum array objects
% q = mpower(q1,q2) performs matrix exponentiation on q1 and q2"""
operand = "^"
operandf = operand + " full("
super = "error('Cannot exponentiate superoperator by an operator');"
matmat = "error('Cannot exponentiate operator by an operator');"
matscalar = ""
scalarmat = ""

generate2(fname,opname,operand,operandf,comment,super,matmat,matscalar,scalarmat)
