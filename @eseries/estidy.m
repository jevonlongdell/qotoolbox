function es2 = estidy(es1,tol1,tol2)
% ESERIES/ESTIDY tidies an exponential series removing terms and merging rates
% es2 = estidy(es1,tol)
%   Rates are merged if they lie within tolerance "tol1".
%   Terms are deleted if their amplitudes are smaller than tolerance "tol2".
%   tol = [reltol,abstol]. Default tolerance is [1e-6,1e-6].

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
%   12-Sept-97   S.M. Tan   	Implemented for Matlab 5 class
%   26-Jan-99    A.C. Doherty 	Corrected max(array,[],1) bugfor Matlab 5.1

if nargin < 2, tol1 = [1e-6,1e-6]; end
if length(tol1)==1, tol1(2)=0; end;
if nargin < 3, tol2 = [1e-6,1e-6]; end
if length(tol2)==1, tol2(2)=0; end;

s = es1.s; es1data = struct(es1.qobase); es1data = es1data.data;
% Find maxima for relative tolerance
smax = max(abs(s)); ls = length(s); tol = max(tol1(1)*smax,tol1(2));
% Find groups of "equal" roots
[sindex,sgroup] = findgroups(real(s),1:ls,tol);
start = find(sgroup);
len = diff([start;ls+1]);
if any(len>1)
   klist = find(len>1);
   for k = klist(:)'
      sub = start(k):start(k)+len(k)-1;
      [sindex(sub),sgroup(sub)] = findgroups(imag(s),sindex(sub),tol);
   end
   start = find(sgroup);
   len = diff([start;ls+1]);
end
if any(len>1)
   singles = find(len==1); which = sindex(start(singles));
   q2.data = sparse(prod(shape(es1)),length(start)); snew = zeros(length(start),1);
   q2.data(:,singles) = es1data(:,which); snew(singles) = s(which);
   groups = find(len>1);
   for k = groups(:)'
      which = sindex(start(k):start(k)+len(k)-1);
      snew(k) = mean(s(which));
      q2.data(:,k) = sum(es1data(:,which),2);
   end
   s = snew;
else
   s = s(sindex);
   q2.data = es1data(:,sindex);
end
q2.dims = dims(es1); q2.shape = shape(es1);
Amax = max(max(abs(q2.data))); 
temp = abs(q2.data);
if size(temp,1)>1
   temp = max(temp);
end   
small = find(temp < max(tol2(1)*Amax,tol2(2)));
if ~isempty(small)
   ok = 1:length(start); ok(small)=[];
   q2.data = q2.data(:,ok); s = s(ok);
end
q2.size = [length(s),1];
es2 = eseries(qo(q2),s);

function [sindex,sgroup] = findgroups(values,index,tol)
[vs,vperm] = sort(values(index));
big = diff(vs) > tol;
sgroup = [1;big];
sindex = index(vperm);
