function fs = mtimes(fs1,fs2)
% FSERIES/MTIMES matrix multiplies a single quantum object and a function series 
% fs = mtimes(fs1,fs2) multiplies together fs1 and fs2. At least one of fs1 and fs2
%  must be a single member quantum object.

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
%   30-Dec-98   S.M. Tan   Initial release
%   26-Jan-99   S.M. Tan   Allow object on either side of function series

if (isa(fs1,'qo') | isa(fs1,'double')) & isa(fs2,'fseries')
   fs1 = qo(fs1);
   if prod(size(fs1))~=1
      error('Expected one operand to be a single member object');
   end
   d = dimprod(dims(fs1),dims(fs2));
   fsshape = dims2shape(d);
   ftype = fs2.ftype; fparam = fs2.fparam; 
   fs2 = struct(fs2.qobase); fs2.ftype = ftype; fs2.fparam = fparam;
   shape2 = fs2.shape;
   if shape2(1)~=shape(fs1,2)
      shape2 = [prod(fs2.shape),1];
   end
   data = sparse(prod(fsshape),prod(fs2.size));
   A = reshape(fs1.data,shape(fs1));   
   for k = 1:prod(fs2.size)
      temp = A * reshape(fs2.data(:,k),shape2);
      data(:,k) = temp(:);
   end   
   fs2.dims = d; fs2.shape = fsshape; fs2.data = data;
   fs = fstidy(fseries(fs2));   
elseif (isa(fs2,'qo') | isa(fs2,'double')) & isa(fs1,'fseries')
   fs2 = qo(fs2);
   if prod(size(fs2))~=1
      error('Expected one operand to be a single member object');
   end
   d = dimprod(dims(fs1),dims(fs2));
   fsshape = dims2shape(d);
   ftype = fs1.ftype; fparam = fs1.fparam; 
   fs1 = struct(fs1.qobase); fs1.ftype = ftype; fs1.fparam = fparam;
   shape2 = shape(fs2);
   if fs1.shape(2)~=shape2(1)
      shape2 = [prod(shape2),1];
   end
   data = sparse(prod(fsshape),prod(fs1.size));
   A = reshape(fs2.data,shape2);   
   for k = 1:prod(fs1.size)
      temp = reshape(fs1.data(:,k),fs1.shape)*A;
      data(:,k) = temp(:);
   end   
   fs1.dims = d; fs1.shape = fsshape; fs1.data = data;
   fs = fstidy(fseries(fs1));   
else
   error('Invalid operands for product');
end

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
