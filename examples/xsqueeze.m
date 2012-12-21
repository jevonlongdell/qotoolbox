% XSQUEEZE illustrates the operator exponential and its use in making a squeezed state

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
% XSQUEEZE illustrates the operator exponential and its use in making a squeezed state
%-----------------------------------------------------------------------------
N = 20;
alpha = -1; 	  % Coherent amplitude of field
epsilon = 0.5i; % Squeezing parameter 
a = destroy(N);
%-----------------------------------------------------------------------------
% Define displacement and squeeze operators
%-----------------------------------------------------------------------------
D = expm(alpha*a'-alpha'*a); % Displacement
S = expm(0.5*epsilon'*a^2-0.5*epsilon*(a')^2); % Squeezing
psi = D*S*basis(N,1); % Apply to vacuum state
g = 2;
%-----------------------------------------------------------------------------
pause % Press [Enter] to calculate Wigner function
%-----------------------------------------------------------------------------
xvec = [-40:40]*5/40; yvec = xvec;
W = wfunc(psi,xvec,yvec,g);
f1 = figure(1); pcolor(xvec,yvec,real(W));
shading interp; title('Wigner function of squeezed state');
%-----------------------------------------------------------------------------
pause % Press [Enter] to calculate Q function
%-----------------------------------------------------------------------------
Q = qfunc(psi,xvec,yvec,g);
f2 = figure(2); pcolor(xvec,yvec,real(Q));
shading interp; title('Q function of squeezed state');
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1); delete(f2);
echo off