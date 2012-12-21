function xfm = ket2xfm(kets,dir,dims)
% QO/KET2XFM converts an array of kets to a transformation 
% xfm = ket2xfm(kets,'fwd',dims) produces forward transform which when multiplied by a ket in the 
%                                old basis gives one in the new
% xfm = ket2xfm(kets,'inv',dims) produces inverse transform which when multiplied by a ket in the 
%                                new basis gives one in the old
% kets is an array of the new unit basis kets expressed in terms of the old
% dir indicates direction, and can be 'fwd' (default) or 'inv'
% dims is an optional specifier for the dimensions of the new ket space

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
%   12-Jan-98   S.M. Tan   Implemented for Matlab5
if ~isket(kets), error('Require array of kets for ket2xfm.'); end

kets = struct(kets.qobase);
d = prod(kets.size);
if ~isequal(d,kets.shape(1)), error('Incorrect number of kets to form a basis.'); end
if nargin == 1, dir = 'fwd'; end
if nargin <= 2, dims = d; end
if ~isa(d,'double') | prod(dims)~=d, error('Incompatible dimensions for ket2xfm.'); end
%
if strcmp(dir,'inv')
   xfm.dims = {kets.dims{1},dims}; xfm.size = [1 1]; xfm.shape = [d d];
   xfm.data = kets.data(:);
elseif strcmp(dir,'fwd')
   xfm.dims = {dims,kets.dims{1}}; xfm.size = [1 1]; xfm.shape = [d d];
   temp = kets.data'; xfm.data = temp(:);
else
   error('Incorrect operands for ket2xfm.');
end
xfm = qo(xfm);