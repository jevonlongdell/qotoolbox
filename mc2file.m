function nexpectations=mc2file(fname,rhs,collapses,expectations,ic,tlist,ntraj,options)
% MC2FILE writes out problem description file for solving a problem using the
%  Monte Carlo wave function algorithm
%  nexpect = mcfile(fname,rhs,collapses,expectations,ic,tlist,ntraj,options)
%   fname: string containing name of problem description file to write
%   rhs:   fseries describing right-hand side of problem
%   collapses: cell array containing fseries describing collapse operators
%   expectations: cell array containing fseries describing operators whose expectations are
%                 required. Set to {} to find state vectors rather than expectation values
%   ic:    qo specifying initial condition
%   tlist: list of times at which solution is required
%   ntraj: number of trajectories to simulate. Can also be a two component vector 
%          [ntraj,ftraj] where ftraj specifies number of trajectories at which
%          expectations are computed
%   options: structure containing options for solution of differential equation
%  Result of simulation is a set of wave functions computed for the specified number
%   of trajectories
%  Returns:
%   nexpect: number of expectation values

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
if nargin<8, options.lmm = 'ADAMS'; end
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
ncollapses = length(collapses);
ncoll = zeros(1,ncollapses);
for k = 1:length(collapses)
   collapses{k} = fseries(collapses{k});
   if ~isequal([N,N],shape(collapses{k}))
   	error('collapse matrices are of the wrong shape');
   end
   ncoll(k) = nterms(collapses{k});
end
nexpectations = length(expectations);
nexpect = zeros(1,nexpectations);
for k = 1:length(expectations)
   expectations{k} = fseries(expectations{k});
   if ~isequal([N,N],shape(expectations{k}))
   	error('expectation matrices are of the wrong shape');
   end
   nexpect(k) = nterms(expectations{k});
end

fid = fopen(fname,'wb');
nR = nterms(rhs);
de2file1(fid,N,nR,ncoll,nexpect);
for k = 1:nR
   params = rhs{k}.params;
   de2file2(fid,rhs{k}.ampl,rhs{k}.type,params{:});
end   
for k = 1:ncollapses
   coll = collapses{k};
   for l = 1:ncoll(k)
      params = coll{l}.params;
      de2file2(fid,coll{l}.ampl,coll{l}.type,params{:});      
   end
end
for k = 1:nexpectations
   expec = expectations{k};
   for l = 1:nexpect(k)
      params = expec{l}.params;
      de2file2(fid,expec{l}.ampl,expec{l}.type,params{:});      
   end
end
if ~isfield(options,'seed'), options.seed = -floor(1000*rand(1)); end
if length(ntraj)==1, ntraj(2)=ntraj(1); end
de2file3(fid,ic,tlist,options.seed,ntraj(1),ntraj(2));

deoptions(fid,options);
fclose(fid);
