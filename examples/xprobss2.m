echo off
% XPROBSS2 Steady-state density matrix calculation for two-level atom in a cavity
%  without unnecessary recomputation of terms in the Liouvillian

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
% XPROBSS2 demonstrates a more efficient way of solving problem in XPROBSS
%-----------------------------------------------------------------------------
kappa = 2; gamma = 0.2; g = 1; wc = 0; w0 = 0;
N = 5; E = 0.5;
nloop = 101;
wlist = linspace(-5,5,nloop);
count1 = zeros(nloop,1);
count2 = zeros(nloop,1);
infield = zeros(nloop,1);
%
ida = identity(N); idatom = identity(2); 
% Define cavity field and atomic operators
a  = tensor(destroy(N),idatom);
sm = tensor(ida,sigmam);
% Hamiltonian
H1 = i*g*(a'*sm - sm'*a) + E*(a'+a);
% Collapse operators
C1    = sqrt(2*kappa)*a;
C2    = sqrt(gamma)*sm;
C1dC1 = C1'*C1;
C2dC2 = C2'*C2;
% Calculate the Liouvillian
L1 = spre(C1)*spost(C1')-0.5*spre(C1dC1)-0.5*spost(C1dC1);
L2 = spre(C2)*spost(C2')-0.5*spre(C2dC2)-0.5*spost(C2dC2);
L12  = L1+L2;
%-----------------------------------------------------------------------------
pause % Press [Enter] to start loop over 100 driving frequencies
%-----------------------------------------------------------------------------
for k = 1:nloop
   wl = wlist(k);
   H = (w0-wl)*sm'*sm + (wc-wl)*a'*a + H1;
   LH = -i * (spre(H) - spost(H)); 
   % Find steady state
   rhoss = steady(LH+L12);
   % Calculate expectation values
   count1(k)  = expect(C1dC1,rhoss);
   count2(k)  = expect(C2dC2,rhoss);
   infield(k) = expect(a,rhoss);
   echo off
   if rem(k,10)==0, fprintf('%d ',k); end
end
fprintf('\n');
echo on
%-----------------------------------------------------------------------------
pause % Press [Enter] to view transmitted intensity and spontaneous emission
%-----------------------------------------------------------------------------
f1 = figure; plot(wlist,real(count1),wlist,real(count2));
xlabel('Detuning'); ylabel('Count rates');
%-----------------------------------------------------------------------------
pause % Press [Enter] to view phase shift of intracavity light
%-----------------------------------------------------------------------------
f2 = figure; plot(wlist,180*angle(infield)/pi);
xlabel('Detuning'); ylabel('Intracavity phase shift');
%-----------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%-----------------------------------------------------------------------------
delete(f1); delete(f2);
echo off