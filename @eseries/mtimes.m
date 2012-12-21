function es = mtimes(es1,es2)
% ESERIES/MTIMES implements matrix multiplication for exponential series
% es = mtimes(es1,es2)

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
%   30-Dec-98    S.M. Tan   Initial implementation
es1 = eseries(es1);
es2 = eseries(es2);
%
q.dims = dimprod(dims(es1),dims(es2));
q.size = [nterms(es1)*nterms(es2),1];
if q.size(1)==0
   es = eszero(q.dims);
   return
end;   
q.shape = dims2shape(q.dims);
q.data = sparse(prod(q.shape),prod(q.size));
%
s = es1.s; es1 = struct(es1.qobase); es1.s = s;
s = es2.s; es2 = struct(es2.qobase); es2.s = s;
s = zeros(q.size);
m = 1; shape2 = es2.shape;
if shape2(1)~=es1.shape(2)
   shape2 = [prod(shape2),1];
end   
for k = 1:length(es1.s)
   A = reshape(es1.data(:,k),es1.shape);
   s1 = es1.s(k);
   for l = 1:length(es2.s)
      s(m) = s1+es2.s(l);
      temp = A * reshape(es2.data(:,l),shape2);
      q.data(:,m) = temp(:);
		m = m+1;
   end
end
es = estidy(eseries(qo(q),s));

function d = dimprod(d1,d2)
if ~iscell(d1{1})
   if prod(d1{1})==1 & prod(d1{2})==1, d = d2; return; end
end
if ~iscell(d2{1})
   if prod(d2{1})==1 & prod(d2{2})==1, d = d1; return; end
end
if isequal(d1{2},d2{1})
   d = {d1{1},d2{2}};
elseif isequal(d1{2},d2)
   d = d1{1};
else
   error('Incompatible matrices in product');
end

function qshape = dims2shape(qdims)
if ~iscell(qdims{1})
   qshape = [prod(qdims{1}),prod(qdims{2})];
else
   qshape = [prod(qdims{1}{1})*prod(qdims{1}{2}),prod(qdims{2}{1})*prod(qdims{2}{2})];
end
