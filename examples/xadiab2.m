echo off
% XADIAB2 solves the master equation for adiabatic transfer of 
%  Zeeman coherence of a multi-level atom to a cavity

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
% XADIAB2 solves the master equation for adiabatic transfer of 
%  Zeeman coherence of a multi-level atom to a cavity using numerical
%  integration. The time-dependent Liouvillian representing the profiles
%  of the classical and cavity fields are specified as function series
%
% See Parkins, Marte, Zoller, Carnal and Kimble, 
%     "Quantum-state mapping between multi-level atoms and cavity 
%       light fields" Phys Rev A, (51), 1578-1596 (1995)
%--------------------------------------------------------------------------
pause % Press [Enter]  to carry out integration
%--------------------------------------------------------------------------
kappa = 0.125;
Jg = 4; Je = 3;
Ne = 2*Je+1; Ng = 2*Jg+1; Nat = Ne+Ng;
Na = 8; delta = 0; gamma = 5;
% Form basis vectors for excited and ground states
for k = 1:Ne; excited{k} = basis(Nat,k); end
for k = 1:Ng; ground{k} = basis(Nat,Ne+k); end
% Form the lowering operators for various polarizations of light
[am,a0,ap] = murelj(Jg,Je);
Am = sparse(Nat,Nat); Am(Ne+1:Ne+Ng,1:Ne)=am; Am = qo(Am);
A0 = sparse(Nat,Nat); A0(Ne+1:Ne+Ng,1:Ne)=a0; A0 = qo(A0);
Ap = sparse(Nat,Nat); Ap(Ne+1:Ne+Ng,1:Ne)=ap; Ap = qo(Ap);
% Form the identity operator for the atom and field
idatom = identity(Nat);
ida = identity(Na);
% Make operators in the composite space
a = tensor(destroy(Na),idatom);
Am = tensor(ida,Am); % For sigma- light
A0 = tensor(ida,A0); % For pi light
Ap = tensor(ida,Ap); % For sigma+ light
%--------------------------------------------------------------------------
% Form Hamiltonian
%--------------------------------------------------------------------------
excited = basis(Nat,1:Ne);
H1 = delta*sum(tensor(ida,excited*excited'));
H2 = i*(Ap-Ap');				% Coeff for classical field
H3 = -i*(a'*A0-A0'*a);		% Coeff for cavity field
% Collapse operators
C = [sqrt(gamma)*Am,sqrt(gamma)*A0,sqrt(gamma)*Ap,sqrt(2*kappa)*a];
%--------------------------------------------------------------------------
% Form Liouvillian
%--------------------------------------------------------------------------
CdC = C'*C;
L1 = -i*(spre(H1)-spost(H1)) + ...
     sum(spre(C)*spost(C') - 0.5*spre(CdC) - 0.5*spost(CdC));
L2 = -i * (spre(H2) - spost(H2));
L3 = -i * (spre(H3) - spost(H3));
%--------------------------------------------------------------------------
% Initial state of atom and field
%--------------------------------------------------------------------------
psi0 = tensor(basis(Na,1),ground{1});
rho0 = psi0 * psi0';
%
N = prod(shape(rho0));
tlist = linspace(0,4,200);
%--------------------------------------------------------------------------
% Write out the file for master equation solution
%--------------------------------------------------------------------------
L = L1 + 50*L2*fn('gauss',2.3,1/sqrt(8*log(2))) + 20*L3*fn('gauss',1.7,1/sqrt(8*log(2)));
ode2file('adiab2i.dat',L,rho0,tlist);
%--------------------------------------------------------------------------
% Call the equation solver
%--------------------------------------------------------------------------
odesolve('adiab2i.dat','adiab2o.dat');
%--------------------------------------------------------------------------
pause; % Press [Enter] to read in output file
%--------------------------------------------------------------------------
fid = fopen('adiab2o.dat','rb');
nphot = zeros(size(tlist));
Qparam = zeros(size(tlist));
for k = 1:length(tlist)
	rho = qoread(fid,dims(rho0),1);
   nphot(k) = expect(a'*a,rho);
   n2 = expect((a'*a)*(a'*a),rho);
   if nphot(k)~=0
      Qparam(k) = (n2 - nphot(k).^2)/nphot(k) - 1;
   end
   echo off
end
echo on
fclose(fid);
f1 = figure(1); plot(tlist,nphot); xlabel('Time'); ylabel('Number of intracavity photons');
%--------------------------------------------------------------------------
pause % Press [Enter] to plot Q parameter
%--------------------------------------------------------------------------
f2 = figure(2); plot(tlist,Qparam); xlabel('Time'); ylabel('Mandl Q parameter');
%--------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%--------------------------------------------------------------------------
delete(f1); delete(f2);
echo off
