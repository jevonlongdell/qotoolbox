function [strings,ampl] = qdisp(psi)
% [STRINGS,AMPL] = QDISP(PSI) displays the state of a quantum register 
%  as a collection of state description strings followed by the 
%  complex amplitude. The output arguments are optional, and are the
%  array of strings and amplitudes.

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
%   10-Mar-99   S.M. Tan   Initial release
if ~isket(psi)
   error('State of quantum register in QDISP must be a ket.')
end
d = dims(psi,1);
n = length(d);
if ~isequal(d,2*ones(n,1))
   error('Input to QDISP is not the state of a quantum register.');
end
psimat = double(psi);
list = find(psimat);
C = cell(n,1);
[C{:}] = ind2sub(2*ones(1,n),list);
str = fliplr(cat(2,C{:}));
str(find(str == 1)) = 'd';
str(find(str == 2)) = 'u';
str = char(str);
if nargout == 0
   for k = 1:length(list)
      fprintf('%s\n',[str(k,:) '  ' num2str(psimat(list(k)))]);
   end
else
   strings = str;
   ampl = full(psimat(list));
end
