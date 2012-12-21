% XPROBTIMEDEP Solution of a master equation with a time-dependent Liouvillian
%  using an external numerical integration routine

%% version 0.15 20-Aug-2002
%
%    Copyright (C) 1996-2002  Sze M. Tan
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
%
%    Address: Physics Department, The University of Auckland, New Zealand
%    Email: s.tan@auckland.ac.nz

echo on
% XPROBTIMEDEP solves for the force on a moving two-level atom in a standing 
%  wave light field as an illustration of the numerical integration of a master
%  equation with a time-dependent Liouvillian. 

%--------------------------------------------------------------------------
pause % Press [Enter] to view PROBTIMEDEP.M, the function called by this routine
%
%--------------------------------------------------------------------------
type probtimedep
%
%--------------------------------------------------------------------------
% Note how:
% * The Hamiltonian H, force F and Liouvillian are formed as exponential series  
% * The time-dependent Liouvillian is written as a function series before being
%    passed to ODE2FILE which writes out a data file for the external integration
%    routine called by ODESOLVE
% * The density matrix result is read in from an external file using QOREAD
%--------------------------------------------------------------------------
pause % Press [Enter] to call PROBTIMEDEP and external integrator
kL = 1;
g0 = sqrt(25/8);
Gamma = 1;
Delta = -5;
v = 2.5;
tlist = linspace(0,10*pi/v,201);
%--------------------------------------------------------------------------
% If the program hangs on the next line, check that the external program
%  solvemc has been installed correctly on the system path and use Ctrl-C
%  to interrupt this script
%--------------------------------------------------------------------------
flist = probtimedep(v,kL,g0,Gamma,Delta,tlist);
%--------------------------------------------------------------------------
% Press [Enter] to view force on atom
% Note that a periodic "steady-state" is reached
%--------------------------------------------------------------------------
pause 
f1 = figure(1); plot(tlist,real(flist));
xlabel('Time'); ylabel('Force on atom');
%--------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%--------------------------------------------------------------------------
delete(f1);
echo off