function de2file2(fid,qo,funcindx,params)
% PRIVATE/DE2FILE2 writes out a the data part of quantum object
%  together with the index of a time-dependent function "funcindx"
%  with parameters "params".

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
%   22-Jan-98   S.M. Tan   Implemented for Matlab 5
if nargin<3, funcindx = 0; end
if nargin<4, params = []; end
if isa(qo,'qo')
  MM = double(qo);
else
  MM = qo;
end
[ii,jj,vv] = find(MM.');
[N,N] = size(MM);
fwrite(fid,2002,'integer*4');		% Identification code
fwrite(fid,N,'integer*4');
fwrite(fid,length(ii),'integer*4');
fwrite(fid,jj,'integer*4');
fwrite(fid,ii,'integer*4');
fwrite(fid,real(vv),'real*4');
fwrite(fid,imag(vv),'real*4');
fwrite(fid,funcindx,'integer*4');
nparam = length(params);
fwrite(fid,nparam,'integer*4');
fwrite(fid,params,'real*4');

