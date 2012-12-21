echo off
% XROTATEWORLD rotates the globe through one revolution

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

echo on
%-----------------------------------------------------------------------------
% XROTATEWORLD Around the world in 18 seconds
%-----------------------------------------------------------------------------
f1 = figure(1);
for k = 0:36
   rotateworld([0,-pi/6,k*2*pi/36],'euler');
   drawnow;
   tic; while(toc)<0.5; end
   echo off
   fprintf('%d ',k);
end
fprintf('\n');
echo on
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1);
echo off