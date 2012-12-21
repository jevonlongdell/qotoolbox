function Q = qgate(nbits,gate,which)
% Q = QGATE(NBITS,GATE,WHICH) returns the operator for a quantum gate 
%  acting on a quantum register with "nbits" q-bits. The matrix which 
%  specifies the "template" of the gate is specified by "gate". This 
%  is wired into the register so that it acts on the q-bits specified 
%  by "which". For example, in obtain the CNOT operator which acts on 
%  q-bits 3 and 5 of a 10 qbit register, use
%    qgate(10,cnot,[3,5])
%  where cnot is the template matrix for a CNOT gate defined on two qbits.
%

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
%   10-Mar-99   S.M. Tan   Initial release


if any(which>nbits) | any(which<1) | any(diff(sort(which))==0)
   error(['In QGATE, the q-bits to act upon must be distinct ' ...
          'and lie in range 1:nbits.']);
end
if ~isoper(gate)
   error('In QGATE, the template gate must be an operator.');
end
if ~isequal(dims(gate,1),2*ones(length(which),1))
   error(['In QGATE, the specified q-bits on which the gate is to act '...
          'are incompatible with the gate template specified']);
end
N = 2^nbits;
Q = sparse(N,N);
selected = ndxlist(nbits,which);
rest = [1:nbits]; rest(which) = [];
rest = ndxlist(nbits,rest);
gmat = double(gate);
[gi,gj] = find(gmat);
for k = 1:length(gi)
   si = selected(gi(k));
   sj = selected(gj(k));
   Q(sub2ind([N,N],rest+si+1,rest+sj+1)) = gmat(gi(k),gj(k));
end
Q = qo(Q,{2*ones(nbits,1),2*ones(nbits,1)});
return
%
function list = ndxlist(nbits,which)
% Compute a list of indicies within the state space of a quantum register of
%  "nbits" q-bits corresponding to the q-bits specified by "which".
if any(which>nbits) | any(which<1)
   error('Arguments to ndxlist are invalid');
end
list = 0;
for k = length(which):-1:1
   list = [list list+2^(nbits-which(k))];
end   

