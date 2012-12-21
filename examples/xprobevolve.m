echo off
% XPROBEVOLVE Time-dependent density matrix calculation for two-level atom in a cavity

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
%-----------------------------------------------------------------------------
% XPROBEVOLVE demonstrates finding the time dependence of the density matrix
%  a two-level atom in a high-Q driven cavity by solution of the master equation.
%--------------------------------------------------------------------------
pause % Press [Enter] to view PROBEVOLVE.M, the function called by this routine
%--------------------------------------------------------------------------
%
type probevolve
%
%--------------------------------------------------------------------------
% Note how:
% * The Liouvillian L is formed from the Hamiltonian and the collapse
%    operators.
% * The solution to the differential equation is achieved in terms of an 
%    exponential series, using ODE2ES. The input to ODE2ES involves the
%    Liouvillian and the initial condition.
% * The expectation values of several operators are found using EXPECT.
%--------------------------------------------------------------------------
pause % Press [Enter] to call PROBEVOLVE
%-----------------------------------------------------------------------------
kappa = 2; gamma = 0.2;
g = 1; wc = 0; w0 = 0; wl = 0;
N = 4; E = 0.5;
tlist = linspace(0,10,200);
[count1,count2,infield] = probevolve(E,kappa,gamma,g,wc,w0,wl,N,tlist);
%-----------------------------------------------------------------------------
pause % Press [Enter] to view transmitted intensity and spontaneous emission
%-----------------------------------------------------------------------------
f1 = figure(1); plot(tlist,real(count1),tlist,real(count2));
xlabel('Time');
ylabel('Transmitted Intensity and Spontaneous Emission');
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1);
echo off