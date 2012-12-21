echo off
% XORBITAL shows a plot of an angular wave function

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
% XORBITAL shows a plot of an angular wave function corresponding to specified
%  state of a l=2 system
%-----------------------------------------------------------------------------
L = 2;
theta = linspace(0,pi,45); phi = linspace(0,2*pi,90);
%-----------------------------------------------------------------------------
% Define state in a J=2 angular momentum basis
%-----------------------------------------------------------------------------
c2 = qo([0;1;0;0;0]); % Components are for m = 2,1,0,-1 and -2 respectively
%-----------------------------------------------------------------------------
pause % Press [Enter] to compute and display angular wave function
%-----------------------------------------------------------------------------
psi = orbital(theta,phi,c2);
f1 = figure(1); sphereplot(theta,phi,psi);
%-----------------------------------------------------------------------------
pause % Press [Enter] to rotate this state by a specified amount
%-----------------------------------------------------------------------------
naxis = rotation([pi/2,pi/2,0],'euler'); % Specify rotation via Euler angles
%-----------------------------------------------------------------------------
% Define the rotation operator as expm(-i*rotation angle*J operator)
%-----------------------------------------------------------------------------
R = expm(-i*combine(naxis',jmat(L))); % Rotation matrix in space of L=2 system
%-----------------------------------------------------------------------------
% Apply rotation in J=2 space
%-----------------------------------------------------------------------------
c2rot = R*c2; % New components
psi = orbital(theta,phi,c2rot);
%-----------------------------------------------------------------------------
pause % Press [Enter] to display rotated angular wave function 
%-----------------------------------------------------------------------------
f2 = figure(2); sphereplot(theta,phi,psi);
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1); delete(f2);
echo off