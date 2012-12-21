function I = esint(ES,t1,t2)
% ESERIES/ESINT integrates an exponential series
% I = esint(ES) integrates an exponential series from zero to infinity
% I = esint(ES,t1) integrates an exponential series from t1 to infinity
% I = esint(ES,t1,t2) integrates an exponential series from t1 to t2

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

A = struct(ES.qobase); 
A = A.data;
s = ES.s;
if nargin==1,
   I = -A*(1 ./s);
elseif nargin==2,
   I = -A*(exp(s*t1)./s);
else
   I = sparse(prod(shape(ES)),1);
   iz = find(s==0);
   if ~isempty(iz),
      I = A(:,iz)*(t2-t1);
      A(:,iz) = [];
      s(iz) = [];
   end
   if length(s) > 0,
      I = I + A*((exp(s*t2)-exp(s*t1))./s);
   end
end
if prod(shape(ES))~=1, I = qo(reshape(I,shape(ES)),dims(ES)); end