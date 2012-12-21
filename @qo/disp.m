function disp(q)
% QO/DISP Displays a quantum object

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
%   18-Sept-97   S.M. Tan   Implemented for Matlab 5
%    8-Jan -98   S.M. Tan   Modified for new structure
q = struct(q.qobase);
fprintf('Hilbert space dimensions ');
if ~iscell(q.dims{1})
   fprintf('[ ');
   fprintf('%d ',q.dims{1}); fprintf('] by [ ');
   fprintf('%d ',q.dims{2}); fprintf(']\n');
else
   fprintf('([ ');
   fprintf('%d ',q.dims{1}{1}); fprintf('] by [ ');
   fprintf('%d ',q.dims{1}{2}); fprintf(']) by ');
   fprintf('([ ');
   fprintf('%d ',q.dims{2}{1}); fprintf('] by [ ');
   fprintf('%d ',q.dims{2}{2}); fprintf('])\n');
end
sq = q.size; nd = length(sq);
if length(sq)>6, error('Arrays of >6 dimensions not supported'); end
sq = [sq ones(1,6)];
fac = [1 cumprod(sq)];
for i1 = 1:sq(1)
   for i2 = 1:sq(2)
      for i3 = 1:sq(3)
         for i4 = 1:sq(4)
            for i5 = 1:sq(5)
               for i6 = 1:sq(6)
                  ii = [i1;i2;i3;i4;i5;i6];
                  if prod(sq)>1
                     fprintf('Member (');
                     fprintf('%d,',ii(1:nd-1));
                     fprintf('%d)\n',ii(nd));
                  end
                  d = reshape(q.data(:,fac(1:6)*(ii-1)+1),q.shape);
                  if all(q.shape<10), d = full(d); end
                  if isempty(d), disp('[]'); else disp(d); end
               end
            end
         end
      end
   end
end
%fprintf('Array size '); disp(sq);