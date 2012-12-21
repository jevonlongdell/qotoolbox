echo off
% XGHZ illustrates calculation of the GHZ states

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
% XGHZ illustrates calculation of the GHZ states
%-----------------------------------------------------------------------------
sx1 = tensor(sigmax,identity(2),identity(2));
sy1 = tensor(sigmay,identity(2),identity(2));

sx2 = tensor(identity(2),sigmax,identity(2));
sy2 = tensor(identity(2),sigmay,identity(2));

sx3 = tensor(identity(2),identity(2),sigmax);
sy3 = tensor(identity(2),identity(2),sigmay);

op1 = sx1*sy2*sy3;
op2 = sy1*sx2*sy3;
op3 = sy1*sy2*sx3;
opghz = sx1*sx2*sx3;
%-----------------------------------------------------------------------------
% We need simultaneous eigenkets of op1,op2,op3 and opghz.
% Classically measured value of opghz should be the product of the measured
%  values of op1, op2, op3
%-----------------------------------------------------------------------------
pause % Press [Enter] to carry out simultaneous diagonalization
%-----------------------------------------------------------------------------
[states,evalues] = simdiag([op1 op2 op3 sx1*sx2*sx3]);
%-----------------------------------------------------------------------------
% The eigenvalues show contradiction with classical prediction
%-----------------------------------------------------------------------------
evalues(:,1)
%-----------------------------------------------------------------------------
% Eigenstate is entangled superposition of up-up-up and dn-dn-dn
%-----------------------------------------------------------------------------
pause % Press [Enter] to view eigenstate
%-----------------------------------------------------------------------------
states{1}
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
echo off