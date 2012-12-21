function [V,D,Vinv,D1,ngood] = approx(A,n)
% QO/PRIVATE/APPROX Computes an approximate decomposition of the matrix A 
%  using the n eigenvectors with largest real part. Note A need not be 
%  symmetrical, so eigenvectors of A' are used to find inverses of 
%  eigenvectors of A.

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
%   20-Feb-98   S.M. Tan   Original implementation
%
[N,N] = size(A);
[V,D] = eigs(A,n,'lr');
[V1,D1] = eigs(A',n,'lr');
%
D = diag(D); D1 = diag(D1);
Vinv = zeros(n,N); bad = [];
for k = 1:n
   [dummy,match] = min(abs(D(k)-D1'));
   if abs(D(k))>1e-9 & dummy > 1e-4*abs(D(k))
      bad = [bad k]; 
   else   
	   % V(:,k) and V1(:,match) are the pair to be normalized
   	v = V(:,k); w = V1(:,match);
	   proj = w'*v; vv = v'*v; ww = w'*w;
   	V(:,k) = v./sqrt(proj*sqrt(vv/ww));
      Vinv(k,:) = w'./sqrt(proj*sqrt(ww/vv));
   end
end
D(bad) = [];
V(:,bad) = [];
Vinv(bad,:) = [];
ngood = length(D);