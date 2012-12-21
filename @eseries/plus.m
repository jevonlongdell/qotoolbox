function es = plus(es1,es2)
% ESERIES/PLUS implements addition for exponential series
% es = plus(es1,es2)

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
%   12-Sept-97   S.M. Tan   Implemented for Matlab 5 class
es  = eseries(es1); es2 = eseries(es2); 

s=es.s; es=struct(es.qobase); es.s=s;
s=es2.s; es2=struct(es2.qobase); es2.s=s;
if isequal(es.dims,{0,0}),  es.dims = es2.dims; es.shape = es2.shape; end
if isequal(es2.dims,{0,0}), es2.dims = es.dims; es2.shape = es.shape; end
if ~isequal(es.dims,es2.dims)
   error('Incompatible operands.');
end   
es.data = [es.data,es2.data]; es.s=[es.s;es2.s]; es.size=size(es.s);
es = estidy(eseries(qo(es),es.s));
