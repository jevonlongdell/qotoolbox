function result = fsval(fs,tarray)
% FSERIES/FSVAL evaluates a function series at a list of times
% FSVAL(fs,tarray) calculates the exponential series "es" at 
%  the points in "tarray" 

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
%   01-Jan-99   S.M. Tan   Initial implementation
%   28-Sep-99   S.M. Tan   Modified for Matlab 5.3
result.dims = dims(fs); 
result.size = size(tarray);
result.shape = shape(fs); 
result.data = sparse(prod(result.shape),prod(result.size));
onesfac = ones(1,prod(size(tarray)));
for k = 1:nterms(fs)
   params = subsref(fs,substruct('{}',{k},'.','param'));
   ftype = subsref(fs,substruct('{}',{k},'.','type')); 
   fac = fsval1(ftype,params{1},tarray);
   fdata = subsref(fs,substruct('{}',{k},'.','data')); 
   result.data = result.data + fdata * fac(:).';
end
if isequal(prod(result.shape),1)
   result = reshape(full(result.data),result.size);
else   
   result = qo(result);
end

function f = fsval1(ftype,fparams,t)
switch ftype
case 0
   if length(fparams)~=0
      error 'Incorrect number of parameters for ftype 0'
   end
   f = ones(size(t));   
case 1
   if length(fparams)~=4
      error 'Incorrect number of parameters for ftype 1'
   end
   f = fparams(1)*exp(i*fparams(2))*exp(-0.5*((t-fparams(3))./fparams(4)).^2);
case 2
   if length(fparams)~=5
      error 'Incorrect number of parameters for ftype 2'
   end
   f = fparams(1)*exp(i*(fparams(2)-fparams(5)*t)).*exp(-0.5*((t-fparams(3))./fparams(4)).^2);
case 3
   if length(fparams)~=2
      error 'Incorrect number of parameters for ftype 3'
   end
   f = exp((fparams(1)+i*fparams(2))*t);   
case 4
   if length(fparams)~=7
      error 'Incorrect number of parameters for ftype 4'
   end
   f = zeros(size(t));
   flag1 = find((t>=fparams(4)-0.5*fparams(5)) & (t<=fparams(6)+0.5*fparams(7)));
   f(flag1) = exp((fparams(2)+i*fparams(3)+fparams(1))*t(flag1));
   flag1 = find(abs(t-fparams(4))<=0.5*fparams(5));
   f(flag1) = f(flag1).*(0.5+0.5*sin(pi*(t(flag1)-fparams(4))./fparams(5)));
   flag1 = find(abs(t-fparams(6))<=0.5*fparams(7));
   f(flag1) = f(flag1).*(0.5+0.5*sin(pi*(fparams(6)-t(flag1))./fparams(7)));
case 5
   if length(fparams)~=2
      error 'Incorrect number of parameters for ftype 5'
   end
   switch fparams(2)
   case 1
      temp = exp(fparams(1)*t);
      f = sqrt(fparams(1)*temp./(temp + 1./temp));
   case 2
      temp = exp(-fparams(1)*t);
      f = sqrt(fparams(1)*temp./(temp + 1./temp));
   case 3
      temp = exp(fparams(1)*t);
      f = fparams(1)*temp./(temp + 1./temp);
   case 4
      temp = exp(fparams(1)*t);
      f = fparams(1)*temp./(temp + 1./temp);
   case 5
      temp = exp(-fparams(1)*t);
      f = fparams(1)*temp./(temp + 1./temp);
   case 6
      temp = exp(fparams(1)*t);
      f = (fparams(1)*temp./(temp + 1./temp)).^2;
   end   
case 6
   if length(fparams)~=3
      error 'Incorrect number of parameters for ftype 6'
   end
   t = min(t,fparams(2));
   switch fparams(3)
   case 1
      temp = exp(-2*fparams(1)*t);
      f = sqrt(fparams(1)./(temp - 1));
   case 2
      f = sqrt(fparams(1));
   case 3
      temp = exp(-2*fparams(1)*t);
      f = fparams(1)./sqrt(temp - 1);
   case 4
      temp = exp(-2*fparams(1)*t);
      f = fparams(1)./(temp - 1);
   case 5
      f = fparams(1);
   case 6
      temp = exp(-2*fparams(1)*t);
      f = fparams(1).^2./(temp - 1);
   end
otherwise
   error('Unknown function type');
end


