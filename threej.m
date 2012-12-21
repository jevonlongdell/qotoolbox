function J=threej(a,b,c,A,B,C)
% THREEJ computes the 3j symbol for angular momentum calculations

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

%   Revision history:
%      Mar-96   S.M. Tan   Original version
%   01-Jan-99   S.M. Tan   Updated for release

if A+B+C~=0, J=0; return; end
R1 = (-1)^(a-b-C)*sqrt(ddelta(a,b,c)*fact(a+A)*fact(a-A)*...
                       fact(b+B)*fact(b-B)*fact(c+C)*fact(c-C));
R2 = 0;
tmin = max([0, b-c-A, B+a-c]);
tmax = min([a+b-c, a-A, b+B]);
for t = tmin:tmax
   R2 = R2 + (-1)^t/fact(t)/fact(c-b+t+A)/fact(c-a+t-B)/...
         fact(a+b-c-t)/fact(a-t-A)/fact(b-t+B);
end
J = R1.*R2;
