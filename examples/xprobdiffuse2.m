echo off
% XPROBDIFFUSE2 solves the problem for the two-level atom in the driven 
%  cavity using the quantum state diffusion algorithm

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
% XPROBDIFFUSE2 solves the problem for the two-level atom in the driven 
%  cavity using the quantum state diffusion algorithm
%--------------------------------------------------------------------------
pause % Press [Enter] to view PROBDIFFUSE2.M, the function called 
%--------------------------------------------------------------------------
%
type probdiffuse2
%
%--------------------------------------------------------------------------
pause % Press [Enter] call PROBDIFFUSE2 and evaluate 100 trajectories
%--------------------------------------------------------------------------
kappa = 2; gamma = 0.2; g = 1;
wc = 0; w0 = 0; wl = 0;
N = 4; E = 0.5;
tlist = linspace(0,10,100);
ntraj = 100;
%--------------------------------------------------------------------------
% If the program hangs on the next line, check that the external program
%  solvesde has been installed correctly on the system path and use Ctrl-C
%  to interrupt this script
%--------------------------------------------------------------------------
[count1,count2,infield] = probdiffuse2(E,kappa,gamma,g,wc,w0,wl,N,tlist,ntraj);
%--------------------------------------------------------------------------
pause % Press [Enter] to plot results
%--------------------------------------------------------------------------
f1 = figure(1); plot(tlist,real(count1),tlist,real(count2));
xlabel('Time');
ylabel('Transmitted Intensity and Spontaneous Emission');
%--------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%--------------------------------------------------------------------------
delete(f1);
echo off