echo off
% XPROBINTMASTER Numerically integrates a master equation

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
%--------------------------------------------------------------------------
% XPROBINTMASTER Numerically integrates a master equation using an external
%  integration routine written in C.
%--------------------------------------------------------------------------
pause % Press [Enter] to view PROBINTMASTER.M, the function called
%--------------------------------------------------------------------------
%
type probintmaster
%
%--------------------------------------------------------------------------
% Notice the calls to ODE2FILE, ODESOLVE and QOREAD which produce the data 
%  file specifying the problem, call the differential equation solver and 
%  read the data back into Matlab.
%--------------------------------------------------------------------------
pause % Press [Enter] to call PROBINTMASTER
%--------------------------------------------------------------------------
kappa = 2; gamma = 0.2; g = 1;
wc = 0; w0 = 0; wl = 0; E = 0.5;
N = 10;
tlist = linspace(0,10,200);
%--------------------------------------------------------------------------
% If the program hangs on the next line, check that the external program
%  solvemc has been installed correctly on the system path and use Ctrl-C
%  to interrupt this script
%--------------------------------------------------------------------------
[count1,count2,infield,check] = probintmaster(E,kappa,gamma,g,wc,w0,wl,N,tlist);
f1 = figure(1); plot(tlist,count1,tlist,count2);
xlabel('Time');
ylabel('Transmitted Intensity and Spontaneous Emission');
%--------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%--------------------------------------------------------------------------
delete(f1);
echo off