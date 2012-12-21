function qq = lcheck(L)
% LCHECK  Check if the superoperator L preserves the trace

%% version 0.15 23-Nov-2001
%
%    Copyright (C) 1996-2001  Sze M. Tan
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
%   23-Nov-2001 S.M. Tan   Initial implementation

if ~issuper(L,'rect')
   error('Input is not a superoperator');
end
L = struct(L.qobase);
n = sqrt(L.shape(1));  % Size of ket Hilbert space
I = eye(n,n);
Iflat = I(:);
q = zeros(prod(L.size),1);
for k = 1:prod(L.size)
   temp = reshape(L.data(:,k),L.shape);
   q(k) = max(abs(Iflat.'*temp))/max(max(abs(temp)));
end
if nargout==0,
   fprintf('For Liouvillian to preserve trace, the following should be near zero:\n');
   fprintf('%g\n',q);
else
   qq = q;
end   

