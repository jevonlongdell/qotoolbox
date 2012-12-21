echo off
% XPROBMULTI2 calculates cycle-averaged force on a uniformly moving 
%  multi-level atom in counter-propagating perpendicularly linearly polarized 
%  light fields

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
% XPROBMULTI2 calculates cycle-averaged force on a uniformly moving 
%  multi-level atom in counter-propagating perpendicularly linearly polarized 
%  light fields
%-----------------------------------------------------------------------------
pause % Press [Enter] to view PROBMULTI2.M, the function called by this routine
%-----------------------------------------------------------------------------
%
type probmulti2
%
%-----------------------------------------------------------------------------
pause % Press [Enter] to scan through the velocities (72 steps)
%-----------------------------------------------------------------------------
kL = 1; Omega = 0.3; Gamma = 1; Delta = -1;
Je = 3/2; Jg = 1/2;
vlist = [linspace(0.0,0.04,41), linspace(0.04,2,31)];
nv = length(vlist);
flist = zeros(nv,1);
for kv = 1:nv
   v = vlist(kv);
   force = probmulti2(v,kL,Jg,Je,Omega,Gamma,Delta);
   flist(kv) = force(0).ampl;
   echo off
   if rem(kv,5)==0, fprintf('%d ',kv); end
end
fprintf('\n');
echo on
%--------------------------------------------------------------------------
pause % Press [Enter] to plot the result
%-----------------------------------------------------------------------------
f1 = figure(1);
plot(vlist,real(flist)); xlabel('Velocity'); ylabel('Force on atom');
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1);
echo off
