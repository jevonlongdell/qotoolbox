function [naxis,U,euler,R] = rotation(params,type)
% ROTATION translates a 3-d rotation into various descriptions
%  [naxis,U,euler,R] = rotation(params,type) takes one of the following 
% inputs:
%
% params = [nx,ny,nz], type = 'axis':             
%   is a rotation about (nx,ny,nz) by angle |(nx,ny,nz)| radians
% params = 2x2 unitary matrix, type = 'SU(2)':    
%   is a rotation specified in SU(2)
% params = [alpha,beta,gamma], type = 'Euler':    
%   is a rotation through Euler angles (alpha,beta,gamma)
% params = 3x3 orthogonal matrix, type = 'SO(3)': 
%   is a rotation specified in SO(3)
%
% Output is the rotation converted to all of the above descriptions.

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

switch lower(type)
case 'euler'
   R = euler2so3(params);
   naxis = so32axis(R);
   U = axis2su2(naxis);
   euler = su22euler(U);
case 'so(3)'
   naxis = so32axis(params);
   U = axis2su2(naxis);
   euler = su22euler(U);
   R = euler2so3(euler);
case 'axis'
   U = axis2su2(params);
   euler = su22euler(U);
   R = euler2so3(euler);
   naxis = so32axis(R);
case 'su(2)'
   euler = su22euler(params);
   R = euler2so3(euler);
   naxis = so32axis(R);
   U = axis2su2(naxis);
otherwise
   error('type should be one of Euler, SO(3), SU(2) or Axis');
end
   
function R = euler2so3(euler)
alpha = euler(1); beta = euler(2); gamma = euler(3);
ca = cos(alpha); sa = sin(alpha);
cb = cos(beta);  sb = sin(beta);
cg = cos(gamma); sg = sin(gamma);
R = [ca -sa 0; sa ca 0; 0 0 1]*[cb 0 sb; 0 1 0; -sb 0 cb]*[cg -sg 0; sg cg 0; 0 0 1];

function naxis = so32axis(R)
if ~isequal(size(R),[3,3]) | norm(R'*R-eye(3),'inf')>1e-6 | norm(R*R'-eye(3),'inf')>1e-6 | det(R)<0
   error('Invalid rotation matrix in SO(3)');
end
[V,D] = eig(R); D = diag(D);
ind=find(abs(D-1)<1.e-6); ind=ind(1);
n = V(:,ind); n = n/norm(n);
nn = n*n'; rn = [0 -n(3) n(2);n(3) 0 -n(1);-n(2) n(1) 0]; enn = eye(3)-nn;
A = [enn(:),rn(:)]; b = R - nn; b = b(:);
result = A\b; phi = atan2(result(2),result(1));
if phi<0, n = -n; phi = -phi; end
naxis = phi * n;

function U = axis2su2(naxis)
if norm(naxis) == 0; U = eye(2); return;
else
   n = naxis/norm(naxis);
   s = sin(norm(naxis)/2);
   a = cos(norm(naxis)/2) - i*n(3)*s;
   b = -n(2)*s - i*n(1)*s;
   U = [a b; -b' a'];
end

function euler = su22euler(U)
if ~isequal(size(U),[2,2]) | norm(U'*U-eye(2),'inf')>1e-6 | norm(U*U'-eye(2),'inf')>1e-6 | det(U)<0
   error('Invalid rotation matrix in SU(2)');
end
a = U(1,1); b = U(1,2); am = abs(a); bm = abs(b);
if am~=0 & bm~= 0
   beta = 2*atan(bm/am);
   alpha = -angle(a/am)-angle(-b/bm);
   gamma = -angle(a/am)+angle(-b/bm);
elseif am==0
   beta = pi; gamma = 0; alpha = -2*angle(-b/bm);
elseif bm==0
   beta = 0; gamma = 0; alpha = -2*angle(-a/am);
end
euler = [alpha;beta;gamma];
