function result = expect(op,state)
% ESERIES/EXPECT calculates expectation values
% expect(op,state) finds expected value of operator "op" for state "state" which may be a
%  density matrix or a ket. Both "op" and "state" are exponential series.

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
%   18-Sep-97   S.M. Tan   Implemented for Matlab 5
%   13-Jan-98   S.M. Tan   Modified for new structure
%   29-Dec-98   S.M. Tan   Fixed bug for states expressed as kets
%   28-Sep-99   S.M. Tan   Modified for Matlab 5.3
op = eseries(op);
state = eseries(state);
result = eszero({1,1});
S(1).type='{}';S(1).subs={':'};S(2).type='.';S(2).subs='ampl';
if isoper(op.qobase) & isoper(state.qobase)
   for k = 1:nterms(op)
      result = result + estidy(eseries(scalar(expect(qo(op.qobase{k}),subsref(state,S))),op.s(k)+state.s));
   end
elseif isoper(op.qobase) & isket(state.qobase)
   for k = 1:nterms(state)
      for l = 1:nterms(state)
         result = result + estidy(eseries(qo(state.qobase{k})'*subsref(op,S)*qo(state.qobase{l}),conj(state.s(k))+op.s+state.s(l)));
      end
   end
else
   error('Invalid operands.');
end
