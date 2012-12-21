function es = ode2es(L,r0,neigs)
% QO/ODE2ES converts ordinary DE into an exponential series
% ES = ode2es(L,r0) calculates exponential series solution
%  of the linear ordinary differential equations with constant
%  coefficients L and initial state r0.

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
%   12-Sep-97   S.M. Tan   Implemented for Matlab 5
%   13-Jan-98   S.M. Tan   Modified for new structure
%   20-Feb-98   S.M. Tan   Allow third argument for approximation using
%                           n eigenvalues with largest real part
if isa(L,'qo') & isa(r0,'qo') & isequal(prod(size(L)),1) & isequal(prod(size(r0)),1)
   dL = dims(L); dr0 = dims(r0);
   if (isequal(dL{2},dr0{1}) & isoper(L) & isket(r0)) | (isequal(dL{2},dr0) & issuper(L) & isoper(r0))
      r = double(r0); r = r(:); n = length(r);
      if nargin<3
         [V,D] = eig(full(double(L)));
         s = diag(D);
      else
         [V,s,Vinv,s1,ngood] = approx(double(L),neigs);
      end
      q.dims = dims(r0); q.size = [length(s),1]; 
      q.shape = shape(r0);
      if nargin<3
         q.data = V*spdiags(V\r,0,n,n);
      else
         q.data = V*spdiags(Vinv*r,0,ngood,ngood);
      end   
      es = estidy(eseries(qo(q),s));
   else
      error('Incompatible operand types for ode2es');
   end
else   
   error('Operands to ode2es should be single member quantum objects.');   
end
