function psi=qstate(string);
% PSI = QSTATE(STRING) Converts string into state of quantum register
%  String should consist of u's and d's. The number of q-bits is 
%  indicated by the length of the string.

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
%   20-Aug-02   S.M. Tan   Changed definition of basis vectors (thanks to Eric Hsu)

string = upper(string);
n = length(string);
if n ~= sum(string=='U') + sum(string=='D')
   error('String input to QSTATE must consist of u''s and d''s only');
end
up = basis(2,2); dn = basis(2,1);
for k = 1:length(string)
   if strcmp(string(k),'U')
      list{k} = up;
   else
      list{k} = dn;
   end
end
psi = tensor(list{:});
