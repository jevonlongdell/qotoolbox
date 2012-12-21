function f = fn(ftype,P1,P2,P3,P4,P5,P6,P7,P8,P9)
% FN generates a term in function series with unit amplitude
%  All parameters are REAL unless otherwise stated
% FN('gauss',mu,sigma) generates exp(-0.5*(t-mu).^2/sigma.^2)
% FN('gauss',mu,sigma,omega) generates 
%                                exp(-0.5*(t-mu).^2/sigma.^2)*exp(-i*omega*t)
% FN('cexp',s) generates exp(s*t) where s can be complex
% FN('pulse',s,tstart,trise,tend,tfall) generates a pulse A(t)*exp(s*t) where 
%  the envelope A(t) is unity between tstart+0.5*trise to tend-0.5*tfall. The 
%  rise and fall are sinusoidal segments.

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
switch lower(ftype)
case 'gauss'
   switch nargin
   case 3 
	  f = fseries(1,1,[1,0,real(P1),real(P2)]);
   case 4
	  f = fseries(1,2,[1,0,real(P1),real(P2),real(P3)]);
   otherwise
     error('Parameters for GAUSS are mu, sigma, [omega]');
   end
case 'cexp'
   switch nargin
   case 2
	  f = fseries(1,3,[real(P1),imag(P1)]);
   otherwise
     error('Parameter for CEXP is s');
   end
case 'pulse'
   switch nargin
   case 6
	  f = fseries(1,4,[0,real(P1),imag(P1),real(P2),real(P3),real(P4),real(P5)]);
   otherwise
     error('Parameters for PULSE are s, tstart, trise, tend, tfall');
   end
case 'symm'   
   switch nargin
   case 3
	  f = fseries(1,5,[real(P1),real(P2)]);
   otherwise
     error('Parameters for symm are kappa and type');
   end
case 'asymm'   
   switch nargin
   case 4
	  f = fseries(1,6,[real(P1),real(P2),real(P3)]);
   otherwise
     error('Parameters for asymm are kappa, tmax and type');
   end
otherwise
   error('Unknown fn type');
end
