echo off
% XPROBDIFFUSE1 calculates decay of a two-sided cavity using the quantum
%  state diffusion algorithm

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
% XPROBDIFFUSE1 calculates decay of a two-sided cavity using the quantum
%  state diffusion algorithm
%--------------------------------------------------------------------------
pause; % Press [Enter] to continue
%--------------------------------------------------------------------------
Da = 0; Na = 11; Ka = 0.2;
psi0 = basis(Na,Na-1); a = destroy(Na);
H0 = Da*a'*a;
C1 = sqrt(3*Ka/2)*a; C2 = sqrt(1*Ka/2)*a;
C1dC1 = C1'*C1; C2dC2 = C2'*C2;
Heff = H0 - 0.5*i*(C1dC1 + C2dC2);
NN = a'*a;
dt = 0.1; tlist = (0:100)*dt;
ntraj = 100;
[nexpect,nphoto] = sde2file('test.dat',-i*Heff,{C1},{C2},{NN},psi0,tlist,ntraj);
%--------------------------------------------------------------------------
pause; % Press [Enter] to call external integration routine
%--------------------------------------------------------------------------
% If the program hangs on the next line, check that the external program
%  solvemc has been installed correctly on the system path and use Ctrl-C
%  to interrupt this script
%--------------------------------------------------------------------------
sdesolve('test.dat','out.dat','photo.dat');
%--------------------------------------------------------------------------
pause; % Press [Enter] to read back the expectation values
%--------------------------------------------------------------------------
fid = fopen('out.dat','rb');
[iter,photnum] = expread(fid,nexpect,tlist);
fclose(fid);
f1 = figure(1);
plot(tlist,real(photnum),tlist,(Na-2)*exp(-2*Ka*tlist));
xlabel('Time'); ylabel('Number of photons in cavity');
%--------------------------------------------------------------------------
pause; % Press [Enter] to read back the photocurrent records
%--------------------------------------------------------------------------
fid = fopen('photo.dat','rb');
for k = 1:ntraj
   [iter,homo,hetero] = phread(fid,nphoto,tlist);    
   echo off
   if (k==ntraj)
      f2 = figure(2);
      plot(tlist,homo); title(['Iteration ',num2str(iter)]); 
      xlabel('Time'); ylabel('Homodyne photocurrent');
   end
end
echo on
fclose(fid);
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1); delete(f2);
echo off



