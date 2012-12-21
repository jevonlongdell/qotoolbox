function es = eseries(q,s)
% ESERIES/ESERIES Constructor method for an exponential series
% eseries(es)  copy constructor
% eseries(q)   convert single matrix or quantum object into a constant exponential series
% eseries(q,s) constructs series with terms q*exp(s*t) where q are quantum objects, 
%               matrices, or cell arrays of matrices

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
%   12-Sep-97   S.M. Tan   First Matlab 5 release
%   27-Dec-98   S.M. Tan   Modified as subclass of qobase

superiorto('qo');
switch nargin
case 0
   es.s = [];
   q = [];
case 1
   if isa(q,'eseries')
      es.s = q.s;
   elseif prod(size(q)) == 0;
      es.s = [];
   elseif isa(q,'qo')
      if prod(size(q)) == 1
         es.s = 0;
      else
         error('Invalid assignment of quantum array object into an exponential series.');
      end
   elseif isa(q,'double')
      es.s = 0;
   else   
      error('Invalid operands to construct an exponential series.');
   end
case 2
   q = qobase(q);
   if ~isequal(length(s),prod(size(q)))
      error('Number of rates must match number of members in object array.');
   end
   es.s = s(:);
end
q = qobase(q); q = q{:};
es.type = 'eseries';
es = class(es,'eseries',q);
