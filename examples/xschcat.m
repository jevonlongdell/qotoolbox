echo off
% XSCHCAT illustrates the formation of a Schrodinger cat

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
% XSCHCAT illustrates the formation of a Schrodinger cat
%-----------------------------------------------------------------------------
N = 20;
alpha1 = -2-i;	  	  % Coherent amplitude 1
alpha2 = 1+i;		  % Coherent amplitude 2
a = destroy(N);
%-----------------------------------------------------------------------------
% Define displacement operators
%-----------------------------------------------------------------------------
D1 = expm(alpha1*a'-alpha1'*a); % Displacement 1
D2 = expm(alpha2*a'-alpha2'*a); % Displacement 2
%-----------------------------------------------------------------------------
% Coherent sum of coherent states
%-----------------------------------------------------------------------------
psi = (1/sqrt(2))*(D1 + D2)*basis(N,1); % Apply to vacuum state
g = 2;
%-----------------------------------------------------------------------------
pause % Press [Enter] to calculate Wigner function
%-----------------------------------------------------------------------------
xvec = [-40:40]*5/40; yvec = xvec;
W = wfunc(psi,xvec,yvec,g);
f1 = figure(1); pcolor(xvec,yvec,real(W));
shading interp; title('Wigner function of Schrodinger cat');
%-----------------------------------------------------------------------------
pause % Press [Enter] to calculate Q function
%-----------------------------------------------------------------------------
Q = qfunc(psi,xvec,yvec,g);
f2 = figure(2); pcolor(xvec,yvec,real(Q));
shading interp; title('Q function of Schrodinger cat');
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1); delete(f2);
echo off