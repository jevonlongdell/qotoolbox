function Ps = esspec(es,warray)
% ESERIES/ESSPEC calculates spectrum from a two-time covariance function.
% Ps = esspec(ES,warray) returns a quantum object with as many members as points in
%  "warray".

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
%   22-Jan-98   S.M. Tan   Modified for new structure
Ps.dims = dims(es); 
Ps.size = size(warray); 
Ps.shape = shape(es); 
Ps.data = sparse(prod(Ps.shape),prod(Ps.size));
if nterms(es)>0
   q = struct(es.qobase);
   for k = 1:prod(size(warray));
      w = warray(k);
      Ps.data(:,k) = 2*real(q.data*(1./(i*w-es.s)));
   end
end   
if isequal(prod(Ps.shape),1)
   Ps = reshape(full(Ps.data),Ps.size);
else   
   Ps = qo(Ps);
end   

