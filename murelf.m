function [Am,A0,Ap] = murelf(Fg,Fe,Jg,Je,I)
% [Am,A0,Ap] = murelf(Fg,Fe,Jg,Je,I)
% Calculate the sparse dipole operator lowering matrices for a Fg to Fe 
%  transition using the "murel" routine. Returned matrix is of size 
%  (2*Fg+1) by (2*Fe+1).

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
%      Mar-96   S.M. Tan   Original version
%   01-Jan-99   S.M. Tan   Updated for release
Mg = -Fg:Fg;
Me = -Fe:Fe;
Am = sparse(2*Fg+1,2*Fe+1);
A0 = sparse(2*Fg+1,2*Fe+1);
Ap = sparse(2*Fg+1,2*Fe+1);
if abs(Fg-Fe)>1, return; end
for k = 1:2*Fg+1
   m = Mg(k);
   if abs(m-1) <= Fe; Am(k,find(Me==m-1))=hyperf(Je,Fe,m-1,Jg,Fg,m,I); end
   if abs(m) <= Fe;   A0(k,find(Me==m))  =hyperf(Je,Fe,m,Jg,Fg,m,I);   end
   if abs(m+1) <= Fe; Ap(k,find(Me==m+1))=hyperf(Je,Fe,m+1,Jg,Fg,m,I); end
end

