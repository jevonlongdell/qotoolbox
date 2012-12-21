function q = qobase(a,dims)
% QOBASE/QOBASE Constructor method for a quantum object

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
%   18-Sept-97   S.M. Tan   	Implemented for Matlab 5
%    8-Jan-98    S.M. Tan		Revised for new structure

switch nargin
case 0
   q.dims = {0,0};
   q.size = [0 0];
   q.shape = [0 0];
   q.data = sparse(0,0);
case 1
   if isa(a,'qobase') | isstruct(a)
      q.dims = a.dims;
      q.size = a.size;
      q.shape = a.shape;
      q.data = a.data;
   else      
      [q.dims,q.size,q.shape,q.data] = qobasestruct(a);
   end      
case 2
   [q.dims,q.size,q.shape,q.data] = qobasestruct(a,dims);
end
q = class(q,'qobase');

function [qdims,qsize,qshape,qdata] = qobasestruct(a,dflag)
if isa(a,'cell')
   a_size = size(a);
   a_shape = size(a{1});
else
   sa = size(a); 
   while length(sa)<4, 
      sa = [sa 1];
   end
   a_size  = sa(3:end);
   a_shape = sa(1:2);
end

if nargin==1,
   qdims = {a_shape(1),a_shape(2)};
   qshape = a_shape;
else   
   if ~iscell(dflag) | ~isequal(size(dflag),[1,2])
      error('dims must be a 2 element cell array of dimensions');
   end
   qdims = dflag;
   if ~iscell(qdims{1})
      qdims = {qdims{1}(:),qdims{2}(:)}; 
      qshape = [prod(qdims{1}),prod(qdims{2})];
   else
      qdims = {{qdims{1}{1}(:),qdims{1}{2}(:)},{qdims{2}{1}(:),qdims{2}{2}(:)}}; 
      qshape = [prod(qdims{1}{1})*prod(qdims{1}{2}),prod(qdims{2}{1})*prod(qdims{2}{2})];
   end
   if ~isempty(a) & ~isequal(qshape,a_shape)
      error('Matrix shape is incompatible with specfied dimensions.');
   end   
end   
      
if isempty(a)
   qsize = [0,0];
   qdata = sparse(prod(qshape),prod(qsize));
elseif isa(a,'double')
   qsize = a_size;
   qdata = sparse(reshape(a,[prod(qshape),prod(qsize)]));
elseif isa(a,'cell')
   qsize = a_size;
   qdata = sparse(prod(qshape),prod(qsize));
   for k = 1:prod(qsize)
      temp=a{k};
      if ~isa(temp,'double'),error('Non-matrix in cell array');end
      if ~isequal(size(temp),qshape),error('Matrix of wrong size in cell array');end
      qdata(:,k)=temp(:);
   end
end