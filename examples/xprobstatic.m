echo off
% XPROBSTATIC Calculates force and momentum diffusion on a stationary 2-level atom
%  in a standing-wave light field

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
% XPROBSTATIC Calculates force and momentum diffusion on a stationary 2-level atom
%  in a standing-wave light field
%--------------------------------------------------------------------------
pause % Press [Enter] to view PROBSTATIC.M, the function called by this routine
%--------------------------------------------------------------------------
%
type probstatic
%
%--------------------------------------------------------------------------
pause % Press [Enter] to scan the position in the standing wave (80 steps)
%--------------------------------------------------------------------------
Delta = 2;
g0 = 1; Gamma = 1; nz = 80; kL = 1;
zlist = linspace(0.001,2*pi,nz);
force = zeros(size(zlist));
diffuse = zeros(size(zlist));
spont = zeros(size(zlist));
for kk = 1:nz
   [force(kk),diffuse(kk),spont(kk)] = probstatic(Delta,Gamma,g0,kL,zlist(kk));
   echo off
   if rem(kk,10)==0, fprintf('%d ',kk); end
end
fprintf('\n');
echo on
%-----------------------------------------------------------------------------
pause % Press [Enter] to view force
%-----------------------------------------------------------------------------
f1 = figure(1); plot(zlist,real(force)); 
xlabel('Position in standing wave');
ylabel('Force on atom');
%-----------------------------------------------------------------------------
pause % Press [Enter] to view momentum diffusion
%-----------------------------------------------------------------------------
f2 = figure(2); plot(zlist,real(diffuse));
xlabel('Position in standing wave');
ylabel('Momentum diffusion');
%-----------------------------------------------------------------------------
pause % Press [Enter] to view spontaneous emission
%-----------------------------------------------------------------------------
f3 = figure(3); plot(zlist,real(spont));
xlabel('Position in standing wave');
ylabel('Spontaneous emission intensity');
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1); delete(f2); delete(f3);
echo off