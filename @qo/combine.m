function q = combine(q1,q2)
% QO/COMBINE multiplies arrays of quantum objects and their members
% q = combine(q1,q2)

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
%   11-Jan-98   S.M. Tan   Modified for new structure
%   28-Sep-99   S.M. Tan   Modified for Matlab 5.3
q = qo;if isa(q1,'qo') & isa(q2,'qo')   
   if isequal(dims(q1,2),dims(q2,1))
      if isequal(size(q1,2),size(q2,1))
         for k = 1:size(q2,2)
            for l = 1:size(q1,1)
               %  q{l,k} = q1{l,1}*q2{1,k};
               q = asg(q,{l,k},ref(q1,{l,1})*ref(q2,{1,k}));
               for m = 2:size(q1,2)
                  %  q{l,k} = q{l,k} + q1{l,m}*q2{m,k};
                  q = asg(q,{l,k},ref(q,{l,k}) + ref(q1,{l,m})*ref(q2,{m,k}));
               end
            end
         end
      else
         error('Incompatible array sizes in combine');
      end
   else
      error('Incompatible matrix dimensions in combine');
   end
elseif isa(q1,'qo') & isa(q2,'double') & ndims(q2)==2
   s2 = size(q2);
   if isequal(size(q1,2),s2(1))
      for k = 1:s2(2)
         for l = 1:size(q1,1)
            % q{l,k} = q1{l,1}*q2(1,k);
            q = asg(q,{l,k},ref(q1,{l,1})*q2(1,k));
            for m = 2:size(q1,2)
               %   q{l,k} = q{l,k} + q1{l,m}*q2(m,k);
               q = asg(q,{l,k},ref(q,{l,k}) + ref(q1,{l,m})*q2(m,k));
            end
         end
      end
   else
      error('Incompatible array sizes in combine');
   end
elseif isa(q2,'qo') & isa(q1,'double') & ndims(q1)==2
   s1 = size(q1);
   if isequal(s1(2),size(q2,1))
      for k = 1:size(q2,2)
         for l = 1:s1(1)
            % q{l,k} = q1(l,1)*q2{1,k};
            q = asg(q,{l,k},q1(l,1)*ref(q2,{1,k}));
            for m = 2:s1(2)
               % q{l,k} = q{l,k} + q1(l,m)*q2{m,k};
               q = asg(q,{l,k},ref(q,{l,k}) + q1(l,m)*ref(q2,{m,k}));
            end
         end
      end
   else
      error('Incompatible array sizes in combine');
   end
else   
   error('Invalid operands for combine');
end

function q1 = ref(q,s)
q1 = subsref(q,substruct('{}',s));

function q1 = asg(q,s,b)
q1 = subsasgn(q,substruct('{}',s),b);
