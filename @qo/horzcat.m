function q = horzcat(q1,varargin)
% QO/HORZCAT implements horizontal concatenation for quantum objects
% q = horzcat(q1,varargin)

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
%   18-Sep-97   S.M. Tan   Implemented for Matlab 5
%    8-Jan-98   S.M. Tan   Modified for new structure
%   21-Dec-98   S.M. Tan   Initial release

if ~isa(q1,'qo'), error('Only qo objects permitted in join.'); end
q = struct(q1.qobase);
for k = 1:length(varargin)
   q = horzcat2(q,varargin{k});
end
q = qo(q);

function q = horzcat2(q1,q2)
if ~isa(q2,'qo'), error('Only qo objects permitted in join.'); end
q2 = struct(q2.qobase);
if prod(q1.size)==0
   q = q2; return;
elseif prod(q2.size)==0
   q = q1; return;
end
if length(q1.size)>2 | length(q2.size)>2
   error('Arrays have more than two dimensions');
end
q = q1;
if isequal(q1.dims,q2.dims) & isequal(q1.size(1),q2.size(1))
   q.size = [q1.size(1) q1.size(2)+q2.size(2)];
   q.data = [q.data q2.data];
else
   if ~isequal(q1.size(1),q2.size(1))
      error('Incompatible array sizes.');
   else
      error('Incompatible Hilbert space dimensions.');
   end   
end
