echo off
% XPROBSS Steady-state density matrix calculation for two-level atom in a cavity

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
% XPROBSS demonstrates calculation of the steady-state of a two-level atom in a high-Q
%  driven cavity by direct solution of the master equation
%--------------------------------------------------------------------------
pause % Press [Enter] to view PROBSS.M, the function called by this routine
%-----------------------------------------------------------------------------
%
type probss
%
%--------------------------------------------------------------------------
% Note how the Liouvillian L is formed and passed to STEADY which finds the
%  steady-state density matrix. The expectation values of several operators
%  are found using EXPECT
%--------------------------------------------------------------------------
pause % Press [Enter] to scan the driving frequency (100 steps) and call PROBSS
%-----------------------------------------------------------------------------
kappa = 2; gamma = 0.2;
g = 1; wc = 0; w0 = 0;
N = 5; E = 0.5;

nloop = 101; wlist = linspace(-5,5,nloop);
count1 = zeros(nloop,1); count2 = zeros(nloop,1); infield = zeros(nloop,1);

for k = 1:nloop
   wl = wlist(k);
   [count1(k),count2(k),infield(k)] = probss(E,kappa,gamma,g,wc,w0,wl,N);
   echo off
   if rem(k,10)==0, fprintf('%d ',k); end
end
fprintf('\n');
echo on
%-----------------------------------------------------------------------------
pause % Press [Enter] to view transmitted intensity and spontaneous emission
%-----------------------------------------------------------------------------
f1 = figure; plot(wlist,real(count1),wlist,real(count2));
xlabel('Detuning'); ylabel('Count rates');
%-----------------------------------------------------------------------------
pause % Press [Enter] to view phase shift of intracavity light
%-----------------------------------------------------------------------------
f2 = figure; plot(wlist,180*angle(infield)/pi);
xlabel('Detuning'); ylabel('Intracavity phase shift');
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1); delete(f2);
echo off