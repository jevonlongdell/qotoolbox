echo off
% XADIAB1 solves Schrodinger's equation for adiabatic transfer of 
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
% XADIAB1 solves Schrodinger's equation for adiabatic transfer of 
%  Zeeman coherence of a multi-level atom to a cavity using numerical
%  integration. The time-dependent Hamiltonian representing the profiles
%  of the classical and cavity fields are specified as function series.
%
% See Parkins, Marte, Zoller, Carnal and Kimble, 
%     "Quantum-state mapping between multi-level atoms and cavity 
%       light fields" Phys Rev A, (51), 1578-1596 (1995)
%--------------------------------------------------------------------------
pause; % Press [Enter] to continue
%--------------------------------------------------------------------------
% Multilevel atom with Zeeman structure
Jg = 4; Je = 3;
Ne = 2*Je+1; Ng = 2*Jg+1; Nat = Ne+Ng;
Na = 10; delta = 0;
% Form basis vectors for excited and ground states
for k = 1:Ne; excited{k} = basis(Nat,k); end
for k = 1:Ng; ground{k} = basis(Nat,Ne+k); end
% Form the lowering operators for various polarizations of light
[am,a0,ap] = murelj(Jg,Je);
Am = sparse(Nat,Nat); Am(Ne+1:Ne+Ng,1:Ne)=am; Am = qo(Am);
A0 = sparse(Nat,Nat); A0(Ne+1:Ne+Ng,1:Ne)=a0; A0 = qo(A0);
Ap = sparse(Nat,Nat); Ap(Ne+1:Ne+Ng,1:Ne)=ap; Ap = qo(Ap);
% Form the identity operator for the atom and field
idatom = identity(Nat); ida = identity(Na);
% Make operators in the composite space
a = tensor(destroy(Na),idatom);
Am = tensor(ida,Am); % For sigma- light
A0 = tensor(ida,A0); % For pi light
Ap = tensor(ida,Ap); % For sigma+ light
%--------------------------------------------------------------------------
pause; % Press [Enter] to form Hamiltonian
%--------------------------------------------------------------------------
excited = basis(Nat,1:Ne);
H1 = delta*sum(tensor(ida,excited*excited'));
H2 = i*(Ap-Ap');				% Coeff for classical field
H3 = -i*(a'*A0-A0'*a);		% Coeff for cavity field
% Initial state of atom and field
psi0 = tensor(basis(Na,1),ground{1});
N = prod(shape(psi0));
tlist = linspace(0,4,200);
%--------------------------------------------------------------------------
% Write out the file for Schrodinger equation solution
% Hamiltonian with two time-dependent light-atom interactions
%--------------------------------------------------------------------------
H = H1 + 50*H2*fn('gauss',2.3,1/sqrt(8*log(2))) + 20*H3*fn('gauss',1.7,1/sqrt(8*log(2)));
ode2file('adiab1i.dat',-i*H,psi0,tlist);
%--------------------------------------------------------------------------
pause; % Press [Enter] to call equation solver
%--------------------------------------------------------------------------
odesolve('adiab1i.dat','adiab1o.dat');
%--------------------------------------------------------------------------
pause; % Press [Enter] to read in output file
%--------------------------------------------------------------------------
% Read in the output data file
fid = fopen('adiab1o.dat','rb');
psi = qoread(fid,dims(psi0),size(tlist));
fclose(fid);
%--------------------------------------------------------------------------
% Calculate expectation values
%--------------------------------------------------------------------------
nphot = expect(a'*a,psi);
n2    = expect((a'*a)^2,psi);
f1 = figure(1); plot(tlist,nphot); xlabel('Time'); ylabel('Number of intracavity photons');
%--------------------------------------------------------------------------
pause % Press [Enter] to calculate Q parameter
%--------------------------------------------------------------------------
Qparam = (n2 - nphot.^2)./nphot - 1;
f2 = figure(2); plot(tlist,Qparam); xlabel('Time'); ylabel('Mandl Q parameter');
%--------------------------------------------------------------------------
pause % Press [Enter] to end demonstration
%--------------------------------------------------------------------------
delete(f1); delete(f2);
echo off
