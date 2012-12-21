function C=clebsch(j1,j2,j3,m1,m2,m3)
%  C=clebsch(j1,j2,j3,m1,m2,m3) calculates the Clebsch-Gordon coefficient
%  for coupling (j1,m1) and (j2,m2) to give (j3,m3).

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

if m3 ~= m1+m2, C=0; return; end
vmin = max([-j1+j2+m3,-j1+m1,0]);
vmax = min([j2+j3+m1,j3-j1+j2,j3+m3]);
C=sqrt((2*j3+1)*fact(j3+j1-j2)*fact(j3-j1+j2)*fact(j1+j2-j3)*...
  fact(j3+m3)*fact(j3-m3)/fact(j1+j2+j3+1)/fact(j1-m1)/fact(j1+m1)...
  /fact(j2-m2)/fact(j2+m2));
S=0;
for v=vmin:vmax
   S=S+(-1)^(v+j2+m2)/fact(v)*fact(j2+j3+m1-v)*fact(j1-m1+v)/...
     fact(j3-j1+j2-v)/fact(j3+m3-v)/fact(v+j1-j2-m3);
end
C = C*S;

function f = fact(n)
f = prod(1:n);
