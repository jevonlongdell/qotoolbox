function [kets,evalues] = simdiag(ops)
% QO/SIMDIAG simultaneously diagonalises a set of commuting Hermitian operators
%  [kets,evalues] = simdiag(ops) takes a composite quantum object whose members are 
%   a set of commuting observables and produces a composite quantum object whose members
%   are kets which are simultaneous eigenstates of the operators. The matrix evalues
%   is of size nmembers(ops)xnmembers(kets) and gives the eigenvalues of the various kets

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
%   7-Jan-98   	S.M. Tan   Implemented for Matlab 5
%   28-Sep-99   S.M. Tan   Modified for Matlab 5.3
if ~isoper(ops), error('SIMDIAG requires operators as its input'); end
for k = 1:prod(size(ops))
   oplist{k} = full(double(subsref(ops,substruct('{}',{k}))));
end
[vlist,evalues] = simdiag1(oplist{:});
kets.dims = {dim(ops),1}; kets.size = [prod(dim(ops)),1];
kets.shape = kets.size; kets.data = vlist;
kets = qo(kets);

function [vlist,evalues] = simdiag1(varargin)
% Carries out simultaneous diagonalization of the Hermitian matrices specified as the input
%  arguments
htol = 1e-6;
nop = length(varargin);
if nop < 1, vlist = []; return; end
s = -1;
for k = 1:length(varargin)
   A = varargin{k};
   [m,n] = size(A);
   if m~=n, error('Matrices must be square'); end;
   if s<0,
      s=n;
   else
      if s~=n, error('All matrices must be of the same size'); end;
   end
   if norm(A-A')/norm(A)>htol, error('Matrices must be Hermitian'); end
   for l = 1:k-1
      B = varargin{l};
      if norm(A*B-B*A)/norm(A*B)>htol, error('Matrices must commute'); end
   end
end
A = varargin{1};
[vlist,d] = eig(A);
d = real(diag(d));
[ds,iperm] = sort(-d); ds = -ds;
vlist = vlist(:,iperm);
k = 1;
while k<length(ds)
   group = find(abs(ds-ds(k))<max(htol,htol*abs(ds(k))));
   if length(group)>1, vlist(:,group) = degen(htol,vlist(:,group),varargin{2:nop}); end
   k = max(group)+1;
end
% Normalize eigenvectors
for k = 1:length(ds)
   vlist(:,k) = vlist(:,k)./norm(vlist(:,k));
end   
if nargout>1
   evalues = zeros(length(varargin),length(ds));
   for k = 1:length(varargin)
      evalues(k,:) = sum(conj(vlist).*(varargin{k}*vlist));
   end   
end   

function vnew = degen(htol,vlist,varargin)
nop = length(varargin);
if nop == 0, vnew = vlist; return; end
A = varargin{1};
[v1,d] = eig(vlist'*A*vlist);
d = real(diag(d));
[ds,iperm] = sort(-d); ds = -ds;
v1 = v1(:,iperm);
vnew = vlist*v1;
k = 1;
while k<length(ds)
   group = find(abs(ds-ds(k))<max(htol,htol*abs(ds(k))));
   if length(group)>1, vnew(:,group) = degen(htol,vnew(:,group),varargin{2:nop}); end
   k = max(group)+1;
end