function d = dim(q)
% QO/DIM returns dimension array of the Hilbert space for the object q
% d = dim(q) is a column vector of dimensions.

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
%   20-Dec-98   S.M. Tan   Initial implementation

if isket(q)
   d = q.dims{1};
elseif isbra(q)
   d = q.dims{2};
elseif isoper(q)
   d = q.dims{1};
elseif issuper(q)
   d = q.dims{1}{1};
else
   error('Value of DIM is undefined.');
end