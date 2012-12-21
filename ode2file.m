function ode2file(fname,rhs,ic,tlist,options)
% ODE2FILE writes out problem description file for solving a system of ODEs
%  odefile(fname,rhs,ic,tlist,options)
%   fname: string containing name of problem description file to write
%   rhs:   fseries describing right-hand side of problem
%   ic:    qo specifying initial condition
%   tlist: list of times at which solution is required
%   options: structure containing options for solution of differential equation

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
%   1-Jan-99   S.M. Tan   Initial version
if nargin<5, options.lmm = 'ADAMS'; end
if exist([pwd '/success.qo']), delete([pwd '/success.qo']); end
% Check that rhs is a function series
if ~isa(ic,'qo')
   error('ic parameter should be a quantum object');
end
if ~isequal(prod(size(ic)),1)
   error('ic parameter should have one member');
end   
N = prod(shape(ic));
rhs = fseries(rhs);
if ~isequal([N,N],shape(rhs))
   error('rhs matrices are of the wrong shape');
end

fid = fopen(fname,'wb');
nR = nterms(rhs);
de2file1(fid,N,nR);
for k = 1:nR
   params = rhs{k}.params;
   de2file2(fid,rhs{k}.ampl,rhs{k}.type,params{:});
end   
de2file3(fid,ic,tlist);
deoptions(fid,options);
fclose(fid);
