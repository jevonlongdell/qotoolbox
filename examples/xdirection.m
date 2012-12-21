echo off
% XDIRECTION computes an approximation to a direction eigenket

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
% XDIRECTION computes an approximation to a direction eigenket in the direct sum space
%  of angular-momentum spaces
%-----------------------------------------------------------------------------
theta = linspace(0,pi,180); phi = linspace(0,2*pi,30);
lmax = 10;
c = cell([lmax+1,1]); % c is a cell array of qo objects, NOT a qo array object
for l = 0:lmax
   c{l+1} = sqrt((2*l+1)/(4*pi))*qo([zeros(l,1);1;zeros(l,1)]);
   echo off
end
echo on
%-----------------------------------------------------------------------------
pause % Press [Enter] to plot approximation to direction eigenket
%-----------------------------------------------------------------------------
psi = orbital(theta,phi,c{:});
f1 = figure(1); sphereplot(theta,phi,psi);
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1);
echo off