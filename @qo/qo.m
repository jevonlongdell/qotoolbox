function q = qo(a,varargin)
% QO/QO Constructor method for a quantum object
% qo(q)      copy constructor
% qo(d)      constructs a quantum object from a double array "d"
% qo(d,dims) constructs a quantum object, from double array "d" with Hilbert
%             space dimensions "dims" specified as a 2 element cell array

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
%   18-Sept-97   S.M. Tan   	Implemented for Matlab 5
%    8-Jan-98    S.M. Tan	Revised for new structure

if nargin<1, a=[]; end
if isa(a,'eseries')
   if isequal(rates(a),0)
      a = a{1};
   else
      error('Cannot convert a non-constant exponential series to a qo object.');
   end   
end
q = class(struct('type','qo'),'qo',qobase(a,varargin{:}));
