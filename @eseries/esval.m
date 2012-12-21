function result = esval(es,tarray)
% ESERIES/ESVAL evaluates an exponential series at a list of times
% ESVAL(es,tlist) calculates the exponential series "es" at 
%  the points in "tarray" 

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
%   12-Jan-98   S.M. Tan   Modified for new structure
result.dims = dims(es); 
result.size = size(tarray);
result.shape = shape(es); 
result.data = sparse(prod(result.shape),prod(result.size));
if nterms(es)>0
   ess = es.s; es = struct(es.qobase); es.s = ess;
   for k = 1:prod(size(tarray));
      t = tarray(k);
      result.data(:,k) = es.data*exp(es.s*t);
   end
end   
if isequal(prod(result.shape),1)
   result = reshape(full(result.data),result.size);
else   
   result = qo(result);
end   