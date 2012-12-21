function [q1,q2] = qobinop(q1,q2)
% QO/QOBINOP changes scalar qo objects to double arrays for use with
%  binary operations

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
%   18-Sept-97   S.M. Tan   Implemented for Matlab 5
%    8-Jan -98   S.M. Tan   Modified for new structure
if isa(q1,'qo')
   if prod(shape(q1))==1; q1 = double(q1); end
end
%
if isa(q2,'qo')
   if prod(shape(q2))==1; q2 = double(q2); end
end
