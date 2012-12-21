function [a,dims] = double(q,cflag)
% QOBASE/DOUBLE converts base quantum object into a matrix
% a = double(q)

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
%   18-Sept-97   S.M. Tan   Implemented for Matlab 5
%    8-Jan -98   S.M. Tan   Modified for new structure

dims = q.dims;
if nargin==1
   if prod(q.shape) == 1
      a = reshape(full(q.data),q.size);
   elseif prod(q.size) ==1
      a = reshape(q.data,q.shape);
   else
      a = zeros([q.shape q.size]);
      for k = 1:prod(q.size)
         a(:,:,k) = reshape(q.data(:,k),q.shape);
      end
   end   
elseif strcmp(cflag,'cell')
   a = cell(q.size);
   for k = 1:prod(q.size)
      a{k} = reshape(q.data(:,k),q.shape);
   end 
else
   error('Unknown option');
end   