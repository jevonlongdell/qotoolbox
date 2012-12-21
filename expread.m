function [iter,varargout] = expread(fid,nexpect,tlist)
% EXPREAD reads in the expectation values from simulation output
%  [iter,varargout] = expread(fid,nexpect,tlist)
% fid: File id of simulation output file
% nexpect: Number of expectation values to read (from mcfile)
% tlist: List of times at which expectations were computed. Must match input
%         to mcfile
% iter: Iteration number at which these expectations were found
% varagout: List of output arguments

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

ntimes = length(tlist);
iter = fread(fid,1,'integer*4');
temp = fread(fid,[2*ntimes,nexpect],'real*4');
nout = max(nargout,1)-1;
for k = 1:nout
   varargout{k} = temp(1:ntimes,k)+i*temp(ntimes+1:2*ntimes,k);
end
