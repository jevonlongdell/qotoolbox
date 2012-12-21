echo off
% XPROBQMC1 calculates decay of a two-sided cavity using the quantum
%  Monte-Carlo algorithm

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
%--------------------------------------------------------------------------
% XPROBQMC1 calculates decay of a two-sided cavity using the quantum
%  Monte-Carlo algorithm. The wave function is written out after each
%  trajectory
%--------------------------------------------------------------------------
pause; % Press [Enter] to continue
%--------------------------------------------------------------------------
Da = 0; Na = 10; Ka = 0.1;
a = destroy(Na); H0 = Da*a'*a;
C1 = sqrt(3*Ka/2)*a; C2 = sqrt(1*Ka/2)*a;
C1dC1 = C1'*C1; C2dC2 = C2'*C2;
Heff = H0 - 0.5*i*(C1dC1 + C2dC2);
psi0 = basis(10,10);
% Write out data file for Quantum Monte Carlo simulation
dt = 0.1;
tlist = (0:100)*dt;
ntraj = 100;
mc2file('test.dat',-i*Heff,{C1,C2},{},psi0,tlist,ntraj);
%--------------------------------------------------------------------------
pause; % Press [Enter] to carry out 100 trajectories
%--------------------------------------------------------------------------
% If the program hangs on the next line, check that the external program
%  solvemc has been installed correctly on the system path and use Ctrl-C
%  to interrupt this script
%--------------------------------------------------------------------------
mcsolve('test.dat','out.dat','clix.dat');
fid = fopen('out.dat','rb');
photnum = zeros(1,length(tlist));
%--------------------------------------------------------------------------
pause; % Press [Enter] to read back the wave functions
%--------------------------------------------------------------------------
for l = 1:ntraj
   if gettraj(fid) ~= l, error('Unexpected data in file'); end
   psi = qoread(fid,dims(psi0),size(tlist));
   photnum = photnum + expect(a'*a,psi)./norm(psi).^2;
   echo off   
end
echo on
photnum = photnum/ntraj;
fclose(fid);
f1 = figure(1);
plot(tlist,photnum,tlist,(Na-1)*exp(-2*Ka*tlist));
xlabel('Time'); ylabel('Number of photons');
%--------------------------------------------------------------------------
pause; % Press [Enter] to read back the classical record
%--------------------------------------------------------------------------
fid = fopen('clix.dat','rb');
clix = clread(fid);
fclose(fid);
%--------------------------------------------------------------------------
% Display times of photocounts on trajectory 1
%--------------------------------------------------------------------------
clix(1).times
%--------------------------------------------------------------------------
% Display photocount channels on trajectory 1
%--------------------------------------------------------------------------
clix(1).channels
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1);
echo off
