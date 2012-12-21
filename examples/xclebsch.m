echo off
% XCLEBSCH illustrates calculation of Clebsch-Gordon coefficients via simultaneous diagonalization

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
% XCLEBSCH illustrates calculation of Clebsch-Gordon coefficients
%  by simultaneous diagonalization of angular momentum operators
%-----------------------------------------------------------------------------
j1 = 1/2;
j2 = 1;
%-----------------------------------------------------------------------------
pause % Define arrays with components of the J operators
%-----------------------------------------------------------------------------
id1 = identity(2*j1+1);
id2 = identity(2*j2+1);
J1 = tensor(jmat(j1),id2);
J2 = tensor(id1,jmat(j2));
%-----------------------------------------------------------------------------
pause % Define total J, squares of J1, J2 and Jtot, and z comp of Jtot
%-----------------------------------------------------------------------------
Jtot = J1 + J2;
J1sq = sum(J1^2); % or use combine([1,1,1],J1^2);
J2sq = sum(J2^2);
Jsqtot = sum(Jtot^2);
Jztot = Jtot{3};
%-----------------------------------------------------------------------------
pause % Carry out simultaneous diagonalization
%-----------------------------------------------------------------------------
[states,evalues] = simdiag([Jsqtot,Jztot,J1sq,J2sq]);
xform = ket2xfm(states,'inv')
%-----------------------------------------------------------------------------
pause % Rows show eigenvalues of Jsqtot, Jztot, J1sq and J2sq for these states
%-----------------------------------------------------------------------------
evalues
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
echo off