function [Am,A0,Ap] = murelj(Jg,Je)
% [Am,A0,Ap] = murelj(Jg,Je) finds coupling strengths for Jg to Je transition.
%  Returns three matrices of Clebsch-Gordon coefficients, each of size (2*Jg+1)
%  by (2*Je+1) corresponding to the relative dipole strengths for sigma-, pi and 
%  sigma+ light,

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
Mg = -Jg:Jg;
Me = -Je:Je;
Am = sparse(2*Jg+1,2*Je+1);
A0 = sparse(2*Jg+1,2*Je+1);
Ap = sparse(2*Jg+1,2*Je+1);
if abs(Jg-Je)>1, return; end
for k = 1:2*Jg+1
   m = Mg(k);
   if abs(m-1) <= Je; Am(k,find(Me==m-1))=clebsch(Jg,1,Je,m,-1,m-1); end
   if abs(m) <= Je;   A0(k,find(Me==m))  =clebsch(Jg,1,Je,m,0,m);    end
   if abs(m+1) <= Je; Ap(k,find(Me==m+1))=clebsch(Jg,1,Je,m,1,m+1);  end
end