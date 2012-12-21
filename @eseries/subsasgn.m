function es1 = subsasgn(es,S,b,tol)
% ESERIES/SUBSASGN performs subscript assignment for an exponential series
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

if nargin<4, tol = [1.e-6,1e-6]; end
if length(tol)==1, tol(2)=0; end;

if length(S)==1
   switch S(1).type
   case '{}'
      b = eseries(b);
      es.qobase = subsasgn(es.qobase,S(1),b.qobase);
      es.s(S(1).subs{:}) = b.s;
   case '.'
      switch lower(S(1).subs)
      case {'ampl', 'amplitude', 'amplitudes'}
         es.qobase{:} = qobase(b);         
      case {'rate', 'rates'}
         es.s(:) = b(:);
      otherwise
         error('Invalid field name');
      end            
   otherwise
      error('Invalid subscript assignment');
   end
elseif length(S)==2
   if S(1).type == '{}' & S(2).type == '.'
      if any(S(1).subs{:}>prod(size(es)))
         error('Index exceeds size of series');
      end
      switch lower(S(2).subs)
      case {'ampl', 'amplitude', 'amplitudes'}
         es.qobase = subsasgn(es.qobase,S(1),qobase(b));         
      case {'rate', 'rates'}
         es.s(S(1).subs{:}) = b(:);
      otherwise
         error('Invalid field name');
      end      
   else
      error('Invalid subscript assignment.');
   end   
else
   error('Invalid subscript assignment.');
end   
es1 = es;