echo off
% XPROB2LEV calculates cycle-averaged force on a uniformly moving 2-level
%  atom in a standing wave light field

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
% XPROB2LEV calculates cycle-averaged force on a uniformly moving 2-level
%  atom in a standing wave light field
%--------------------------------------------------------------------------
pause % Press [Enter] to view PROB2LEV.M, the function called by this routine
%-----------------------------------------------------------------------------
%
type prob2lev
%
%--------------------------------------------------------------------------
pause % Press [Enter] to scan through the velocities (50 steps)
%-----------------------------------------------------------------------------
kL = 1; g0 = sqrt(25/8); Gamma = 1; Delta = -5;
vlist = linspace(0,10,50);
nv = length(vlist);
flist = zeros(nv,1);
for kv = 1:nv
   v = vlist(kv);
   force = prob2lev(v,kL,g0,Gamma,Delta);
   flist(kv) = force(0).ampl; % Select constant term in eseries
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