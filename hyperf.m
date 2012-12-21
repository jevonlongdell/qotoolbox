function m = hyperf(Je,Fe,Me,Jg,Fg,Mg,I)
% m = hyperf(Je,Fe,Me,Jg,Fg,Mg,I) calculates the relative matrix element for a
%  transition from upper level (Je,Fe,Me) to lower level (Jg,Fg,Mg) with nuclear
%  spin I.

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
%      Apr-96   S.M. Tan   Initial implementation
%   01-Jan-99   S.M. Tan	Updated for release
%   20-Aug-02   S.M. Tan  Corrected typographical error (thanks to Herbert Crepaz)

m = (-1)^(1+I+Je+Fe+Fg-Me)*sqrt(2*Fe+1)*sqrt(2*Fg+1)*sqrt(2*Je+1)*...
    threej(Fe,1,Fg,-Me,Me-Mg,Mg)* sixj(Fe,1,Fg,Jg,I,Je);
