function result = subsref(es,S)
% ES/SUBSREF performs subscripting for an exponential series
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
%   30-Dec-98   S.M. Tan   Modified for new structure

index = 1;
switch S(index).type
case '{}'
   if prod(size(S(index).subs))~=1
      error('Only one subscript is allowed.')
   end
   es1.qobase = es.qobase{S(index).subs{:}};
   es1.s = es.s(S(index).subs{:});
   index = index + 1;
   es1 = eseries(qo(es1.qobase),es1.s);
case '()'
   if prod(size(S(index).subs{:}))~=1
      error('Only one subscript is allowed.')
   end
   es1 = eseries(esterm(es,S(index).subs{:}),S(index).subs{:});    
   index = index + 1;
otherwise
   es1 = es;
end
if index>length(S)
   result = estidy(es1);
   return
end
q = struct(es1.qobase);
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
      result = qo(es1.qobase);
   case {'rate', 'rates'}
      result = es1.s;
   otherwise
      error('Unknown field');
   end
   index = index + 1;
otherwise
   error('Invalid indexing operation');
end
if index<=length(S)
   error('Invalid indexing operation');
end
