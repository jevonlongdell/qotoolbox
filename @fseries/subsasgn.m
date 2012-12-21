function f1 = subsasgn(f,S,b,tol)
% FSERIES/SUBSASGN performs subscript assignment for a function series
%  This operation is invalid and returns an error message

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
%   21-Dec-98    S.M. Tan	 Initial release

if length(S)==1
   switch S(1).type
   case '{}'
      b = fseries(b);
      f.qobase = subsasgn(f.qobase,S(1),b.qobase);
      f.ftype(S(1).subs{:}) = b.ftype;
      f.fparam(S(1).subs{:}) = b.fparam;
   case '.'
      switch lower(S(1).subs)
      case {'ampl', 'amplitude', 'amplitudes'}
         f.qobase{:} = qobase(b);       
      case {'type', 'types'}
         f.ftype(:) = b(:);
      case {'param', 'params', 'parameter', 'parameters'}
         f.fparam{:} = b{:};
      otherwise
         error('Invalid field name');
      end            
   otherwise
      error('Invalid subscript assignment');
   end
elseif length(S)==2
   if S(1).type == '{}' & S(2).type == '.'
      if any(S(1).subs{:}>prod(size(f)))
         error('Index exceeds size of series');
      end
      switch lower(S(2).subs)
      case {'ampl', 'amplitude', 'amplitudes'}
         f.qobase = subsasgn(f.qobase,S(1),qobase(b));
      case {'type', 'types'}
         f.ftype(S(1).subs{:}) = b(:);
      case {'param', 'params', 'parameter', 'parameters'}
         f.fparam(S(1).subs{:}) = b;
      otherwise
         error('Invalid field name');
      end      
   else
      error('Invalid subscript assignment.');
   end   
else
   error('Invalid subscript assignment.');
end   
f1 = f;