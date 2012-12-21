function s2 = sixj(j1,j2,j3,J1,J2,J3)
% SIXJ computes the 6j symbol for angular momentum calculations

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
s2 = 0;
tmin = max([j1+j2+j3,j1+J2+J3,J1+j2+J3,J1+J2+j3,0]);
tmax = min([j1+j2+J1+J2,j3+j2+J3+J2,j1+j3+J1+J3]);
for t = tmin:tmax
   s2 = s2+(-1)^t * fact(t+1)/fact(t-j1-j2-j3)/fact(t-j1-J2-J3)/...
          fact(t-J1-j2-J3)/fact(t-J1-J2-j3)/fact(j1+j2+J1+J2-t)/...
          fact(j3+j2+J3+J2-t)/fact(j1+j3+J1+J3-t);
end
s2 = s2*sqrt(ddelta(j1,j2,j3)*ddelta(j1,J2,J3)*ddelta(J1,j2,J3)*ddelta(J1,J2,j3));

