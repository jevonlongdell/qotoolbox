function q1 = subsref(q,S)
% QOBASE/SUBSREF performs subscripting for a quantum base object
% q{m1,m2,...} returns {m1,m2,...}'th array member of a quantum object
% q{m1,m2,...}(s) returns a double matrix consisting of subscript s of q{m1,m2,...}
% {m1,m2,...}  may be omitted for a quantum object with one member

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
%   
%    21-Dec-98    S.M. Tan	 Initial release
q1 = subsref(q.qobase,S);
if isa(q1,'qobase'), q1 = qo(q1); end   
