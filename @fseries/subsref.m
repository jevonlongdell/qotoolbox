function result = subsref(f,S)
% FSERIES/SUBSREF performs subscripting for a function series
%  es{index} returns coefficient associated with index

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
%   12-Sep-97   S.M. Tan   Implemented for Matlab 5 class
%   12-Jan-97   S.M. Tan   Modified for new structure

index = 1;
switch S(index).type
case '{}'
   if prod(size(S(index).subs))~=1
      error('Only one subscript is allowed.')
   end
   f1 = struct(f.qobase{S(index).subs{:}});
   f1.ftype = f.ftype(S(index).subs{:});
   f1.fparam = f.fparam(S(index).subs{:});
   index = index + 1;
   f1 = fseries(f1);
otherwise
   f1 = f;
end
if index>length(S)
   result = f1;
   return
end
q = struct(f1.qobase);
switch S(index).type
case '.'
   switch lower(S(index).subs)
   case 'dims'
      result = q.dims;
   case 'size'
      result = q.size;
   case 'shape'
      result = q.shape;
   case 'data'
      result = q.data;
   case {'ampl', 'amplitude', 'amplitudes'}
      result = qo(f1.qobase);
   case {'type', 'types'}
      result = f1.ftype;
   case {'param', 'params', 'parameter', 'parameters'}
      result = f1.fparam;
   otherwise
      error('Unknown field in quantum object');
   end
   index = index + 1;
otherwise
   error('Invalid indexing operation');
end
if index<=length(S)
   error('Invalid indexing operation');
end
