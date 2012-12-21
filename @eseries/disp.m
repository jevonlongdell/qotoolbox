function disp(es)
% ESERIES/DISP Display method for exponential series

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
%   12-Sep-97   S.M. Tan   Implemented for Matlab 5 class
%   12-Jan-98   S.M. Tan   Modified for new structure
%   27-Dec-98   S.M. Tan   Modified as class of qobase
if isempty(es.s)
   fprintf('Zero exponential series.\n');
   dispdims(dims(es.qobase));
else
   fprintf('Exponential series: %d terms.\n',prod(size(es.qobase)));
   dispdims(dims(es.qobase));
   for k = 1:length(es.s)
      disp(['Exponent{' num2str(k) '} = (' num2str(es.s(k)) ')']);
      if all(shape(es.qobase)<10)
         disp(full(double(qo(es.qobase{k}))));
		else         
         disp(double(qo(es.qobase{k})));
      end
   end
end

function dispdims(qdims)   
fprintf('Hilbert space dimensions ');
if ~iscell(qdims{1})
   fprintf('[ ');
   fprintf('%d ',qdims{1}); fprintf('] by [ ');
   fprintf('%d ',qdims{2}); fprintf('].\n');
else
   fprintf('([ ');
   fprintf('%d ',qdims{1}{1}); fprintf('] by [ ');
   fprintf('%d ',qdims{1}{2}); fprintf(']) by ');
   fprintf('([ ');
   fprintf('%d ',qdims{2}{1}); fprintf('] by [ ');
   fprintf('%d ',qdims{2}{2}); fprintf(']).\n');
end
