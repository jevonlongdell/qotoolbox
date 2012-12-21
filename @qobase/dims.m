function d = dims(q,k,l)
% QO/DIMS returns Hilbert space dimensions cell array of a quantum object.
% Use DIM to return dimensions as a single column vector.
% d = dims(q) is a 1x2 cell array of dimensions
% dk = dims(q,k) is equivalent to d=dims(q);dk=d{k};
% dkl = dims(q,k,l) is equivalent to d=dims(q);dkl=d{k}{l};

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
%   10-Jan-98   S.M. Tan   Implemented for Matlab 5

d = q.dims;
if nargin>1,
   d = d{k};
end
if nargin>2,
   d = d{l};
end   