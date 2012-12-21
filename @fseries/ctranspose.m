function fs = ctranspose(fs)
% FSERIES/CTRANSPOSE Conjugate transpose for function series
% fs = ctranspose(fs)

%% version 0.11 26-Jan-1999
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
%   25-Jan-99    M.J. Dunstan    copy of eseries/ctranspose


FS.n = [2, 3, 4];
FS.param = [5, 2, 3];

% find functions with imaginary parameters
for j = 1:length(FS.n),
    index = find(fs.ftype == FS.n(j));
    if ~isempty(index),
        % fs.fparam{index}(FS.param(j)) = -fs.fparam{index}(FS.param(j));
        temp = reshape([fs.fparam{index}].', ...
                       length(fs.fparam{index(1)}),length(index)).';
        temp(:,FS.param(j)) = - temp(:,FS.param(j));  
        fs.fparam(index) = num2cell(temp,2);
    end
end
fparam = fs.fparam; ftype = fs.ftype;
fs = struct(qobase(qo(fs.qobase)'));
fs.fparam = fparam; fs.ftype = ftype;
fs = fseries(fs);
