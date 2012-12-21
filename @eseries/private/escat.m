function es2 = escat(es1,a,s,tol1,tol2)
% ESERIES/PRIVATE/ESCAT concatenates exponential series and a term
% es2 = escat(es1,a,s,tol1,tol2)
%   es1 is input exponential series, a*exp(s*t) is additional term.
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
%   12-Sep-97   S.M. Tan   Implemented for Matlab 5 class
%   12-Jan-98   S.M. Tan   Modified for new structure

if nargin < 4, tol1 = [1e-6,1e-6]; end
if length(tol1)==1, tol1(2)=0; end;
if nargin < 5, tol2 = [1e-6,1e-6]; end
if length(tol2)==1, tol2(2)=0; end;

nt = nterms(es1);
if nt == 0 % New exponential series
   if isequal(dims(es1),{0,0}) | isequal(dims(es1),dims(a))
      es2 = eseries(a,s);
   else
      error('Incompatible Hilbert space dimensions.');
   end      
else
   if ~isequal(dims(es1),dims(a))
      error('Incompatible Hilbert space dimensions.');
   end
   q2 = qo(es1.qobase); s2 = es1.s;
   closeroot = find(abs(s-es1.s) <= max(tol1(1)*abs(s),tol1(2)));
   if isempty(closeroot) % This is a new rate
      q2{nt+1} = a;
      s2 = [ s2; s ];
   else % This rate is already in the series
      [dummy,closeroot] = min(abs(s-es1.s));
      b = q2{closeroot} + a;
      if norm(b,'inf') < max(tol2(1)*norm(a,'inf'),tol2(2)) % Remove term
         s2 = s2([1:closeroot-1,closeroot+1:nt]);
         q2 = q2{[1:closeroot(1)-1,closeroot(1)+1:nt]};
      else
         q2{closeroot}= b;
      end
   end
   es2 = eseries(q2,s2);
end
