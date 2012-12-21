function psi = orbital(theta,phi,varargin)
% ORBITAL calculates an angular wave function on a sphere
%  psi = orbital(theta,phi,ket1,ket2,...) calculates the angular wave function on a 
%   sphere at the mesh of points defined by theta and phi which is 
%          SUM  c    Y  (theta,phi)
%          l,m   lm   lm
%  where c_{lm} are the coefficients specified by the list of kets. Each ket has 2l+1 
%   components for some integer l.

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
%   17-Jan-98   S.M. Tan   Original version
%   01-Jan-99   S.M. Tan   Updated for release
theta = theta(:).'; phi = phi(:);
psi = 0;
for k = 1:length(varargin)
   ket = varargin{k};
   if ~isket(ket) | prod(size(ket))>1; error('Invalid ket in call to orbital'); end
   sk = shape(ket); l = (sk(1)-1)/2;
   if ~isequal(l,fix(l)); error('Kets must have odd number of components in orbital'); end
   if l == 0
      SPlm = sqrt(2)*ones(size(theta));
   else   
      SPlm = legendre(l,cos(theta),'sch');
      SPlm = SPlm;
   end
   fac = sqrt((2*l+1)/(8*pi));
   psi = psi + sqrt(2)*fac*ket(l+1)*ones(size(phi))*SPlm(1,:);
   for m = 1:l
      psi = psi + (-1).^m * fac*ket(l-m+1)*exp(i*m*phi)*SPlm(m+1,:);
   end
   for m = -l:-1
      psi = psi + fac*ket(l-m+1)*exp(i*m*phi)*SPlm(abs(m)+1,:);
   end
end

   