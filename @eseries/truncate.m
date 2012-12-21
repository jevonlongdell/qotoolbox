function q1 = truncate(q,indices)
% ESERIES/TRUNCATE truncates the space of a quantum object "q" using the list of 
%  "indices". 
% e.g. if the vector space dimensions of q are [4,5,3], and we wish to truncate the
%  space by selecting directions 2:3, 1:5 and 1:2 in the subspaces, set 
%  indices = {2:3,1:5,1:2}. The output will have vector space dimensions [2,5,2]
% Alternatively, we can select a collection of individual directions. For example if
%  indices = [3,4,2; 1,4,2; 2,1,2; 4,1,3], we are selecting a four dimensional 
%  subspace spanned by directions given by the rows of indices.

%% version 0.15 25-Nov-2001
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
%   25-Nov-2001   S.M. Tan   Initial implementation
q1 = eseries(truncate(qo(q.qobase),indices),q.s);