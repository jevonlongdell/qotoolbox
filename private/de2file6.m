function de2file6(fid,x0,c0,tlist,seed,ntraj,ftraj,refine)
% PRIVATE/DE2FILE6 writes out the initial conditions, the list of times 
%  at which the solution is required and the seed for the random number 
%  generator

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
%   22-Jan-98   S.M. Tan   Implemented for Matlab 5
if nargin<5, seed=0; end
if nargin<6, ntraj=1; end
if nargin<7, ftraj=ntraj; end
if nargin<8, refine=1; end
if isa(x0,'qo')
  x0 = x0.data;
end
x0 = full(x0);
fwrite(fid,4003,'integer*4');	% Identification code
fwrite(fid,real(x0),'real*4');
fwrite(fid,imag(x0),'real*4');
if isa(c0,'qo')
  c0 = c0.data;
end
c0 = full(c0);
fwrite(fid,real(c0),'real*4');
fwrite(fid,imag(c0),'real*4');
fwrite(fid,length(tlist),'integer*4');
fwrite(fid,real(tlist),'real*4');
fwrite(fid,seed,'integer*4');
fwrite(fid,ntraj,'integer*4');
fwrite(fid,ftraj,'integer*4');
fwrite(fid,refine,'integer*4');

