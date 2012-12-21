% Quantum Toolbox.
% Version 0.10 11-Jan-1999
%
%   qdemos      - run demonstrations in examples directory
%
% Functions returning special objects
%   basis       - basis ket vector or vectors
%   create      - boson creation operator
%   destroy     - boson annihilation operator
%   identity    - identity operator
%   jmat        - angular momentum matrix
%   sigmam      - lowering operator for 2-level system
%   sigmap      - raising operator for 2-level system
%   sigmax,y,z  - Pauli matrices
%   eszero      - Zero exponential series
%   fszero      - Zero function series
%   fn          - scalar-valued function for assembling function series
%   scalar      - Converts double matrix to quantum array of scalars
%
% Functions for all objects (class qobase)
%   dim        - Vector of Hilbert space dimensions
%   dims       - Cell array of Hilbert space dimensions
%   double     - Extract data as matrix of doubles
%   isbra      - True if object contains bra (row) vectors
%   isket      - True if object contains ket (column) vectors
%   isoper     - True if object is a square matrix representing an operator
%   issuper    - True if object is a square matrix representing a superoperator
%   length     - Length of array of quantum objects (max(size))
%   permute    - Permutes order of Hilbert spaces in a tensor product
%   shape      - Shape of matrix representation of each object member
%   size       - Size of object array
%
% Quantum array object functions (class qo)
%   combine    - Array multiplication
%   diag       - Diagonal entries
%   expect     - Expectation value of operator
%   expm       - Operator / superoperator exponential
%   isequal    - Test for equality
%   ket2xfm    - Convert set of kets to a basis transformation operator
%   norm       - Computes norm of object
%   ode2es     - Converts initial value problem to an exponential series
%   ptrace     - Computes partial trace
%   qfunc      - Computes Husimi Q function
%   simdiag    - Simultaneous diagonalization of commuting operators
%   spost      - Convert postmultiplication by operator to a superoperator
%   spre       - Convert premultiplication by operator to a superoperator
%   steady     - Finds steady-state solution
%   sum        - Finds sum of array members
%   tensor     - Tensor product of quantum objects
%   trace      - Trace
%   wfunc      - Computes Wigner function
%   operations - (Conjugate) transpose ' and .'
%              - Unary + and unary -
%              - Elementwise addition +, subtraction -, multiplication .*
%                 left and right division .\ ./ , power .^
%              - Matrix multiplication *, left and right division \ /, power ^
%   fields     - .dims, .size, .shape, .data
%   {}         - Array member access
%   ()         - Matrix element access
%
% Exponential series functions (class eseries)
%   es2fs      - Convert exponential series to a function series
%   esint      - Definite integral of exponential series
%   esspec     - Convert covariance exponential series to spectrum
%   esterm     - Extract amplitude of a single term in an exponential series
%   estidy     - 'Tidies' an exponential series, placing it in standard form
%   esval      - Evaluates an exponential series at specified points
%   expect     - Expectation value of operator
%   isequal    - Tests for equality
%   mcfrac     - Matrix continued fraction solution of master equation
%   nterms     - Number of terms in exponential series
%   ptrace     - Computes partial trace
%   rates      - Vector of rates in exponential series
%   spost      - Convert postmultiplication by operator to a superoperator
%   spre       - Convert premultiplication by operator to a superoperator
%   trace      - Trace
%   operations - (Conjugate) transpose ' and .'
%              - Unary + and unary -
%              - Elementwise addition +, subtraction -, multiplication .*
%              - Matrix multiplication *, right division /
%   fields     - .ampl, .rates, .dims, .size, .shape, .data
%   {}         - Extract term(s) by member index
%   ()         - Extract term(s) by rate
%
% Function series functions (class fseries)
%   fstidy     - Removes terms with negigible amplitudes
%   fsval      - Evaluates function series
%   nterms     - Number of terms in series
%   ptrace     - Computes partial trace
%   trace      - Trace
%   operations - Unary + and unary -
%              - Elementwise addition +, subtraction -
%              - Matrix multiplication *
%   fields     - .ampl, .type, .param, .dims, .size, .shape, .data
%   {}         - Extract term(s) by member index
%
% Functions for external program interface
%   ode2file    - Write out data file for solving ordinary diff eqn
%   mc2file     - Write out data file for quantum Monte Carlo calculation
%   sde2file    - Write out data file for state diffusion calculation
%   odesolve    - Call ordinary diff eqn solver
%   mcsolve     - Call quantum Monte Carlo solver
%   sdesolve    - Call state diffusion equation solver
%   eulersolve  - Call first-order Euler method state diffusion eqn solver
%   clread      - Reads in a classical record file
%   expread     - Reads in expectation values from file
%   phread      - Reads in photocurrent record from file
%   qoread      - Reads in quantum array object from file
%   gettraj     - Read in trajectory number from file
%
% Special matrices
%   murelf      - Coupling strengths for F-F transition
%   murelj      - Coupling strengths for J-J transition
%   rotation    - Rotation matrices in various forms
%   orbital     - Evaluate angular wave function on sphere
%   sphereplot  - Plot angular wave function on sphere
%
% Quantum computing functions
%   qstate      - Creates a multi-qubit state from a string
%   qdisp       - Displays a multi-qubit state
%   cnot        - Generates controlled NOT (template) matrix
%   snot        - Generates Hadamard (sqrt NOT) (template) matrix
%   fredkin     - Generates Fredkin gate (template) matrix
%   toffoli     - Generates Toffoli gate (template) matrix
%   qgate       - Generates matrix for a gate acting on a 
%                  register from a template

%   Copyright (c) 1996-99 by S. M. Tan (s.tan@auckland.ac.nz)

