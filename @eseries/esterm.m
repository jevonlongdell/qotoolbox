function q = esterm(es,s,tol)
% ESERIES/ESTERM extracts terms with rates s from an exponential series
% q = esterm(es,s) yields a quantum object array of the same shape as s.
% q = esterm(es,s,tol) allows user to specify a tolerance for s values.
%     tol = [reltol,abstol]. Default tolerance is [1e-6,1e-6].

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
%   11-Oct-97   S.M. Tan   Implemented for Matlab 5
%   27-Dec-98   S.M. Tan   Modified to include relative and absolute tolerances

if nargin<3, tol = [1.e-6,1e-6]; end
if length(tol)==1, tol(2)=0; end;
q.dims = dims(es); q.size = size(s); q.shape = shape(es);
q.data = sparse(prod(q.shape),prod(q.size));
%
if nterms(es)>0
   ess = es.s; es = struct(es.qobase); es.s = ess;
   for k = 1:prod(q.size)
      indx = find(abs(s(k)-es.s)<=max(tol(1)*max(abs(es.s)),tol(2)));
      if ~isempty(indx)
         q.data(:,k) = sum(es.data(:,indx),2);
      end
   end
end   
q = qo(q);