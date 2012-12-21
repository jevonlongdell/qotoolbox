function g = phasemap(m)
% PHASEMAP   Circular periodic colour map for phase data
%   PHASEMAP(M) returns an M-by-3 matrix containing a phase colormap.
%   PHASEMAP, by itself, is the same length as the current colormap.
%
%   For example, to reset the colormap of the current figure
%     colormap(phasemap)

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
%   17-Jan-98   S.M. Tan   Original version
%   01-Jan-99   S.M. Tan   Updated for release
if nargin < 1, m = size(get(gcf,'colormap'),1); end
theta = 2*pi*(0:m-1)/m;
circ = exp(i*theta');
% Vertices of colour triangle
vred = -2; vgreen = 1-sqrt(3)*i; vblue = 1+sqrt(3)*i;
vredc = vred-circ; vgreenc = vgreen-circ; vbluec = vblue-circ;
red   = abs(imag(vgreenc.*conj(vbluec)));
green = abs(imag(vbluec.*conj(vredc)));
blue  = abs(imag(vredc.*conj(vgreenc)));
g = 1.5*[red green blue]./abs(imag((vred-vgreen)*conj(vred-vblue)));
