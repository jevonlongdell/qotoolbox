function result = clread(fid)
% CLREAD reads in a file containing the classical record of collapses. 
%  result = clread(fid);
%  Output is a structure array with fields times and channels
%   result(i).times is array of times that collapses occured on trajectory i
%   result(i).channels is array of collapse channels which occured on 
%                      trajectory i

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
temp = fread(fid,[2,inf],'real*4');
ntraj = sum(temp(2,:) == 0);
indx = find(temp(2,:) == 0);

for k = 1:ntraj-1
   result(k).times = temp(1,indx(k)+1:indx(k+1)-1);
   result(k).channels = temp(2,indx(k)+1:indx(k+1)-1);
end
result(ntraj).times = temp(1,indx(ntraj)+1:end);
result(ntraj).channels = temp(2,indx(ntraj)+1:end);
