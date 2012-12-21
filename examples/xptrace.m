echo off
% XPTRACE illustrates computation of partial traces

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
% XPTRACE illustrates calculation of partial traces
%-----------------------------------------------------------------------------
up = basis(2,1); dn = basis(2,2);
bell = (tensor(up,up)+tensor(dn,dn))/sqrt(2);
%-----------------------------------------------------------------------------
% PTRACE of a Bell state is the 50-50 mixture
%-----------------------------------------------------------------------------
pause % Either specify a state as a ket ...
%-----------------------------------------------------------------------------
ptrace(bell,1)
%-----------------------------------------------------------------------------
% ... or as a density matrix
%-----------------------------------------------------------------------------
ptrace(bell*bell',1)
%-----------------------------------------------------------------------------
% Now consider measuring the second particle, and obtaining the result "left"
%-----------------------------------------------------------------------------
pause % Press [Enter] to continue
%-----------------------------------------------------------------------------
left = (up + dn)/sqrt(2);
%-----------------------------------------------------------------------------
% Action of this measurement is to apply the projection operator Omegaleft 
%-----------------------------------------------------------------------------
Omegaleft = tensor(identity(2),left*left');
after = Omegaleft*bell;
%-----------------------------------------------------------------------------
% Probability of result
%-----------------------------------------------------------------------------
prob = norm(after)^2
after = after/norm(after);
%-----------------------------------------------------------------------------
pause % Press [Enter] to find reduced density matrix of particle 1
%-----------------------------------------------------------------------------
rho = ptrace(after,1)
%-----------------------------------------------------------------------------
% Check that it is pure
%-----------------------------------------------------------------------------
trace(rho^2)
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
echo off