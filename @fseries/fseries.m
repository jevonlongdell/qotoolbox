function f = fseries(q,ftype,fparam)
% FSERIES/FSERIES Constructor method for a function series
% fs(q,ftype,fparam)  single term series with amplitude q, function type ftype and parameters fparam
% fs(f) copy constructor

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
superiorto('qo');
switch nargin
case 0
   f.ftype = [];
   f.fparam = {};
   q = qobase([]);
case 1
   if isa(q,'fseries')
      f = q;
      return
   elseif isa(q,'struct')
      f.ftype = q.ftype;
      f.fparam = q.fparam;
      q = qobase(q);               
		f.type = 'fseries';
      f = class(f,'fseries',q);
      return
   else
      q = qobase(q);
      if prod(size(q))==0
		   f.ftype = [];
		   f.fparam = {};
      else
         f.ftype = 0;
         f.fparam = {[]};
      end      
   end
case 2
   if prod(size(ftype))~=1
      error('Invalid function type');
   end
   q = qobase(q);
   f.ftype = ftype;
   f.fparam = {[]};
case 3   
   q = qobase(q);
   f.ftype = ftype;
   if iscell(fparam)
      f.fparam = fparam;
   else
      f.fparam = {fparam(:)'};
   end
end
nampl = prod(size(q));
if ~isequal(nampl,prod(size(f.fparam))) | ...
      ~isequal(nampl,prod(size(f.ftype)))
   error('Amplitude object has incorrect number of members.')
end
f.type = 'fseries';
f = class(f,'fseries',q);
