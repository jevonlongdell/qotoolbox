function result = qoread(fid,dims,size)
% QOREAD reads in a quantum object array of dimensions "dims" and size "size" 
%  from a simulation data file
% result = qoread(fid,dims,size);

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
%   5-Jan-99   S.M. Tan   Initial version
if ~exist('success.qo')
   error('External integration program failed. (File success.qo not found)');
end   
if ~iscell(dims), error('DIMS should be a two cell array of Hilbert space dimensions.'); end
N = prod(dims{1}) * prod(dims{2});
M = prod(size); if length(size)<2, size = [size 1]; end
result = fread(fid,[2*N,M],'real*4');
q.dims = dims; q.size = size; q.shape = [prod(dims{1}),prod(dims{2})];
q.data = result(1:N,:) + i*result(N+1:2*N,:);
result = qo(q);
