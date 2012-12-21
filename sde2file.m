function [nexpectations,nphoto]=sde2file(fname,rhs,homodyne,heterodyne,expectations,ic,tlist,ntraj,options)
% SDE2FILE writes out problem description file for solving a problem using the
%  stochastic differential equation (state diffusion) algorithm
%  sdefile(fname,rhs,homodyne,heterodyne,expectations,ic,tlist,ntraj,options)
%   fname: string containing name of problem description file to write
%   rhs:   fseries describing right-hand side of problem
%   homodyne: cell array containing fseries describing collapse operators for homodyne measurements
%   heterodyne: cell array containing fseries describing collapse operators for heterodyne measurements
%   expectations: cell array containing fseries describing operators whose expectations are
%                 required. Set to {} to find state vectors rather than expectation values
%   ic:    qo specifying initial condition
%   tlist: list of times at which solution is required
%   ntraj: number of trajectories to simulate. Can also be a three component vector 
%          [ntraj,ftraj,refine] where ftraj specifies number of trajectories at which
%          expectations are computed and refine is the number of substeps between each 
%          subinterval of tlist over which the noise is kept constant
%   options: structure containing options for solution of differential equation
%  Result of simulation is a set of wave functions computed for the specified number
%   of trajectories

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
if nargin<9, options.lmm = 'ADAMS'; end
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
nhomodyne = zeros(1,length(homodyne));
for k = 1:length(homodyne)
   homodyne{k} = fseries(homodyne{k});
   if ~isequal([N,N],shape(homodyne{k}))
   	error('homodyne matrices are of the wrong shape');
   end
   nhomodyne(k) = nterms(homodyne{k});
end
nheterodyne = zeros(1,length(heterodyne));
for k = 1:length(heterodyne)
   heterodyne{k} = fseries(heterodyne{k});
   if ~isequal([N,N],shape(heterodyne{k}))
   	error('heterodyne matrices are of the wrong shape');
   end
   nheterodyne(k) = nterms(heterodyne{k});
end
nphoto = [length(homodyne),length(heterodyne)];
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
de2file4(fid,N,nR,nhomodyne,nheterodyne,[],nexpect);
for k = 1:nR
   params = rhs{k}.params;
   de2file2(fid,rhs{k}.ampl,rhs{k}.type,params{:});
end   
for k = 1:length(homodyne)
   homo = homodyne{k};
   for l = 1:nhomodyne(k)
      params = homo{l}.params;
      de2file2(fid,homo{l}.ampl,homo{l}.type,params{:});      
   end
end
for k = 1:length(heterodyne)
   hetero = heterodyne{k};
   for l = 1:nheterodyne(k)
      params = hetero{l}.params;
      de2file2(fid,hetero{l}.ampl,hetero{l}.type,params{:});      
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
if length(ntraj)<=1, ntraj(2)=ntraj(1); end
if length(ntraj)<=2, ntraj(3)=1; end
de2file3(fid,ic,tlist,options.seed,ntraj(1),ntraj(2),ntraj(3));

deoptions(fid,options);
fclose(fid);
