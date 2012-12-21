function odesolve(infile,outfile)
% ODESOLVE(infile,outfile) calls the external equation solver routines 
%  passing the specified input and output files

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
%   1-Jan-99   S.M. Tan   Initial version
%   26-Jan-99  M. Dunstan Added check for operating system
sf = [pwd '/success.qo'];
ff = [pwd '/failure.qo'];
if exist(sf), delete(sf); end
if exist(ff), delete(ff); end

cmd = '!solvemc';
if strcmp(computer,'PCWIN')
    eval([cmd ' ' infile ' ' outfile ' &']);
    while ~exist(sf) & ~exist(ff),
	tic; pause(2); 
	if toc<2, 
	    error('User interrupt.');   
	end;
    end
else
    eval([cmd ' ' infile ' ' outfile ]);
end

if exist(ff), type(ff); error; end
