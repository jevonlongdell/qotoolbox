function [naxis,U,euler,R] = rotateworld(params,type)
% ROTATEWORLD illustrates 3-d rotation on globe
%  [naxis,U,euler,R] = rotateworld(params,type) takes one of the following inputs:
% params = [nx,ny,nz], type = 'axis':             is a rotation about (nx,ny,nz) by angle |(nx,ny,nz)| radians
% params = 2x2 unitary matrix, type = 'SU(2)':    is a rotation specified in SU(2)
% params = [alpha,beta,gamma], type = 'Euler':    is a rotation through Euler angles (alpha,beta,gamma)
% params = 3x3 orthogonal matrix, type = 'SO(3)': is a rotation specified in SO(3)
% Output is the rotation converted to all of the above descriptions.
% ROTATEWORLD applies transformation to map of world

%   Copyright (c) 1996-98 by S.M. Tan
%   Revision history:
%   18-Jan-98   S.M. Tan   Initial implementation

[naxis,U,euler,R] = rotation(params,type);
h = findobj('Tag','RotateWorldGlobe');
% Sphere of 24 makes 15 degrees between lat and long lines
[x,y,z]=sphere(24);
Rxyz = R * [x(:).'; y(:).'; z(:).'];
x(:) = Rxyz(1,:);
y(:) = Rxyz(2,:);
z(:) = Rxyz(3,:);
if isempty(h)
   load topo
   clf; surface(x,y,z,'FaceColor','texture','CData',topo,'Tag','RotateWorldGlobe');
   % Now view the globe so the Greenwich meridian is directly
   % facing the viewer
   view(-90,0);
   colormap(topomap1);
   axis equal;
   set(gca,'Visible','off');
else
   set(h,'XData',x,'YData',y,'ZData',z);
end
