function fs = fstidy(fs1,tol)
% FSERIES/FSTIDY tidies up a function series, removing small terms
% fs = fstidy(fs1,tol)
%   fs1 is input function series. Terms with identical parameters
%    are merged.
%   Terms are deleted if amplitude is smaller than tol
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
%   30-Dec-98   S.M. Tan   	Initial release
%   26-Jan-99   A.C. Doherty 	Corrected max(array,[],1) bug for Matlab 5.1
%   28-Sep-99   S.M. Tan   	Modified for Matlab 5.3

if nargin < 5, tol = [1e-6,1e-6]; end
if length(tol)==1, tol(2)=0; end;

ntnew = 0;
nt = nterms(fs1);
fs = fseries(qo([],dims(fs1)));
for k = 1:nt
   ftype = subsref(fs1,substruct('{}',{k},'.','type')); 
   fparam = subsref(fs1,substruct('{}',{k},'.','param'));
   done = 0;
   for l = 1:ntnew
      ftypel =  subsref(fs,substruct('{}',{l},'.','type')); 
      fparaml = subsref(fs,substruct('{}',{l},'.','param'));
      if isequal(ftype,ftypel) & isequal(fparam,fparaml)
         S = substruct('{}',{l},'.','ampl');
         S1 = substruct('{}',{k},'.','ampl');
         % fs{l}.ampl = fs{l}.ampl + fs1{k}.ampl;
         fs = subsasgn(fs,S,subsref(fs,S)+subsref(fs1,S1));
         done = 1; break;
      end
   end
   if ~done
      ntnew = ntnew + 1;
      params = subsref(fs1,substruct('{}',{k},'.','param'));
      ampl = subsref(fs1,substruct('{}',{k},'.','ampl'));
      type = subsref(fs1,substruct('{}',{k},'.','type'));
      % fs{ntnew} = fseries(fs1{k}.ampl,fs1{k}.type,params{:});
      fs = subsasgn(fs,substruct('{}',{ntnew}),fseries(ampl,type,params{:}));
   end
end
% Check if any amplitudes have become small
ftype = fs.ftype; fparam = fs.fparam; fs = struct(fs.qobase); fs.ftype = ftype; fs.fparam = fparam;
Amax = max(abs(fs.data));
temp = abs(fs.data);
if size(temp,1)>1
   temp = max(temp);
end   
small = find(temp < max(tol(1)*Amax,tol(2)));
if ~isempty(small)
   ok = 1:ntnew; ok(small)=[];
   fs.data = fs.data(:,ok); fs.fparam = fs.fparam(ok); fs.ftype = fs.ftype(ok);
end
fs.size = [length(fs.ftype),1];
fs = fseries(fs);
