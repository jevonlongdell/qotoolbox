function deoptions(fid,options)
% PRIVATE/DEOPTIONS writes out option information for the ODE solver
%  "method" specifies the linear multistep method, which can be either 'ADAMS'
%    for the Adams method (non-stiff problems) or 'BDF' for the backward 
%    differentiation formula (stiff problems)
%  "iter" is the method of iterative solution used in the implicit algorithm. Can
%    be either 'FUNCTIONAL' for functional iteration or 'NEWTON' for Newton iteration
%    using the diagonal of the Jacobian
%  "reltol" is the relative tolerance (should be a scalar)
%  "abstol" is the absolute tolerance. Can either be a scalar or a vector of same length
%    as the problem. Same tolerance is used for both real and imaginary parts.
% The use of DEOPTIONS is optional, but if present, it must follow DE2FILE3

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
%   29-Nov-98   S.M. Tan   Implemented for Matlab 5

if ~isfield(options,'lmm'), method = 'ADAMS'; else method = options.lmm; end
if ~isfield(options,'iter'), iter = 'FUNCTIONAL'; else iter = options.iter; end
if ~isfield(options,'reltol'), reltol = 1e-6; else reltol = options.reltol; end
if ~isfield(options,'abstol'), abstol = 1e-6; else abstol = options.abstol; end


fwrite(fid,1001,'integer*4');	% Identification code
method = lower(method);
if strcmp(method,'adams')
   deford = 12;
   fwrite(fid,0,'integer*4');
elseif strcmp(method,'bdf')
   deford = 5;
   fwrite(fid,1,'integer*4');
else
   error('METHOD must be ''ADAMS'' or BDF''');
end
if ~isfield(options,'maxord'), maxord = deford; else maxord = options.maxord; end

iter = lower(iter);
if strcmp(iter,'functional')
   fwrite(fid,0,'integer*4');
elseif strcmp(iter,'newton')
   fwrite(fid,1,'integer*4');
else
   error('ITER must be ''FUNCTIONAL'' or ''NEWTON''');
end

if ~isfield(options,'mxstep'), mxstep = 500; else mxstep = options.mxstep; end
if ~isfield(options,'mxhnil'), mxhnil = 10; else mxhnil = options.mxhnil; end
if ~isfield(options,'h0'), h0 = 0; else h0 = options.h0; end
if ~isfield(options,'hmax'), hmax = 0; else hmax = options.hmax; end
if ~isfield(options,'hmin'), hmin = 0; else hmin = options.hmin; end

fwrite(fid,reltol,'real*4');
fwrite(fid,length(abstol),'integer*4');
fwrite(fid,real(abstol),'real*4');
fwrite(fid,maxord,'integer*4');
fwrite(fid,mxstep,'integer*4');
fwrite(fid,mxhnil,'integer*4');
fwrite(fid,h0,'real*4');
fwrite(fid,hmax,'real*4');
fwrite(fid,hmin,'real*4');