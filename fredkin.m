function Q = fredkin
% FREDKIN computes the operator for a Fredkin gate
% The last two inputs are swapped if the first input is u

% A B C  A' B' C'
% ---------------
% d d d  d  d  d
% d d u  d  d  u
% d u d  d  u  d
% d u u  d  u  u
% u d d  u  d  d
% u d u  u  u  d
% u u d  u  d  u
% u u u  u  u  u

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

uuu = qstate('uuu'); uud = qstate('uud'); udu = qstate('udu'); udd = qstate('udd');
duu = qstate('duu'); dud = qstate('dud'); ddu = qstate('ddu'); ddd = qstate('ddd');
Q = ddd*ddd' + ddu*ddu' + dud*dud' + duu*duu' + udd*udd' + uud*udu' + udu*uud' + uuu*uuu';


