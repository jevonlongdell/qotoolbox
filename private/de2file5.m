function de2file5(fid,N,nR,Clist,Olist)
% PRIVATE/DE2FILE5 writes out description of problem to file "fid".
%  "N" is the number of unknowns in the system of equations,
%  "nR" is the number of terms on the RHS of the differential equations,
%  "Clist" is the number of terms in the function series for each of
%          the possible collapses
%  "Olist" is the number of terms in the function series for each of
%          the operators whose expectations are required

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

% Delete file which indicates successful completion of routine
if exist([pwd '/success.qo']), delete([pwd '/success.qo']); end
if nargin<4, Clist = []; end
if nargin<5, Olist = []; end
fwrite(fid,4001,'integer*4');	% Identification code
fwrite(fid,N,'integer*4');
fwrite(fid,nR,'integer*4');
fwrite(fid,length(Clist),'integer*4');
fwrite(fid,Clist,'integer*4');
fwrite(fid,length(Olist),'integer*4');
fwrite(fid,Olist,'integer*4');

