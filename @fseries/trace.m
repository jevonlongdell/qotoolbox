function result = trace(fs)
% FSERIES/TRACE calculates trace of a function series
% result = trace(fs)

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

%   Copyright (c) 1996-97 by S.M. Tan
%   Revision history:
%   06-Jan-99   S.M. Tan   Initial release
nt = nterms(fs);
ftype=fs.ftype; fparam=fs.fparam; 
fs=struct(fs.qobase); 
fs.ftype=ftype; fs.fparam=fparam;
temp = sparse(1,nt);
for k = 1:nt
   temp(k) = sum(diag(reshape(fs.data(:,k),fs.shape)));
end
fs.data = temp;
fs.dims = {[1],[1]}; fs.shape = [1,1];
result = fstidy(fseries(fs));
