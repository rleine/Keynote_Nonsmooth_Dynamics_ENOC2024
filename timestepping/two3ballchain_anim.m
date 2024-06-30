function F = two3ballchain_anim(sys,t1,q1,t2,q2,aviname)
% two3ballchain_anim.m: animation file for sys_3ballchain.m
%
% makes one video with two simulations:
% top = simulation 1, bottom = simulation 2
%
% Remco Leine, 2024

scaling = 2;
midxpos = 10;
midypos = 0;


R = scaling*sys.R;

n = 3;
q1 = scaling*q1 + midxpos;
q2 = scaling*q2 + midxpos;

t = t1; %This demands that t1 = t2, which is not exactly fulfilled

if nargin<6, aviname = 'test.avi'; end
if nargin<7, antialias = false; end

framespersecond = 30;
acceleration = 1;
N = length(t);
t0 = t(1);
tE = t(N);
frames = (tE-t0)*framespersecond/acceleration;
K = floor(N/frames);

scrsz = [1 1 1920 1200];
fig = figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
set(fig,'Color','w');
axis([-5 30 -25 10])
axis equal;
set(fig, 'DoubleBuffer', 'on'); 


gray = '#EBECEC';
mygreen = '#6CAB6C';

v = VideoWriter(aviname);
open(v);

set(gca,'xlim',[-5 30],'ylim',[-15 10],'nextplot','replacechildren','Visible','off');


for j = 1:n
  balls1(j) =  circlefun('init');
end 
for j = 1:n
  balls2(j) =  circlefun('init');
end 

%time = text(0,-5,'t = 0','FontSize',14);
 y1 = midypos - 3*R;
 y2 = midypos + 3*R;

text(midxpos,y1 - 2*R,'$\Delta t = 0.001$','Interpreter','latex','FontSize',30);
text(midxpos,y2- 2*R,'$\Delta t = 0.001005$','Interpreter','latex','FontSize',30);

for i=1:K:N  
  x1 = q1(1:n,i);
  x2 = q2(1:n,i);
 
  circlefun('draw',balls1(1),x1(1),y1,R,'r');
  circlefun('draw',balls1(2),x1(2),y1,R,'magenta');
  circlefun('draw',balls1(3),x1(3),y1,R,'b');
 
  circlefun('draw',balls2(1),x2(1),y2,R,'r');
  circlefun('draw',balls2(2),x2(2),y2,R,'magenta');
  circlefun('draw',balls2(3),x2(3),y2,R,'b');
 
  F = getframe(gca);   
 
  writeVideo(v,F);
end
close(fig)
close(v);

%------------------------------------------------------------------


function varargout = supportfun(flag,object,x,y,a,b,color)
% support
switch flag
 case 'init'
  object =  patch;
  varargout{1} = object;
 case 'draw'
  Xdata = x+ [-a;+a;+a;-a];
  Ydata = [y;y;y-b;y-b];
  set(object,'Xdata',Xdata,'Ydata',Ydata,'FaceColor',color,'Edgecolor','none');
  varargout{1} = 1;
end
%------------------------------------------------------------------

function varargout = blockfun(flag,object,x,y,phi,a,b,color)
% block
switch flag
 case 'init'
  object =  patch;
  varargout{1} = object;
 case 'draw'
  Xdata0 = [-a;-a;a;a];
  Ydata0 = [-b;+b;+b;-b];
  R = [cos(phi) -sin(phi);sin(phi) cos(phi)];
  Z = R*[Xdata0';Ydata0'];
  Xdata = x+Z(1,:)';
  Ydata = y+Z(2,:)';
  set(object,'Xdata',Xdata,'Ydata',Ydata,'FaceColor',color, 'Edgecolor','none');
  varargout{1} = 1;
end


%------------------------------------------------------------------
function varargout = springfun(flag,object,x0,y0,x1,y1,a)
% spring
switch flag
 case 'init'
  varargout{1} = line;
 case 'draw'
  dx = [0;0;-1;1;-1;1;0;0]*a;
  u = sqrt((y1-y0)^2+(x1-x0)^2);
  if x1-x0~=0
   phi = atan((y1-y0)/(x1-x0));
  else
   phi = sign(y1-y0)*pi/2;
  end
  dy = [12;10;9;7;5;3;2;0]/12*u;
  xdata = dx*sin(phi)+dy*cos(phi)+x0;
  ydata = dy*sin(phi)+dx*cos(phi)+y0;
  set(object,'Xdata',xdata,'Ydata',ydata,'LineWidth',1);  
  varargout{1} = 1;
end

%------------------------------------------------------------------
function varargout = dashpotfun(flag,object,x0,y0,x1,y1,a,h)
% dashpot
if nargin<8, h=2; end;
switch flag
 case 'init'
  object.ul = line;
  object.pot = line;
  object.piston =line;
  object.stick = line;
  varargout{1} = object;
 case 'draw'
  u = sqrt((y1-y0)^2+(x1-x0)^2);
  if x1-x0~=0
   phi = atan((y1-y0)/(x1-x0));
  else
   phi = sign(y1-y0)*pi/2;
  end
  dx = [0;0];
  dy = [0;-a];
  set(object.ul,'Xdata',dx*sin(phi)+dy*cos(phi)+x1,'Ydata',dy*sin(phi)-dx*cos(phi)+y1,'LineWidth',1);

  dx = [-a;-a;a;a];
  dy = [-2.5;-1;-1;-2.5]*a;
  set(object.pot,'Xdata',dx*sin(phi)+dy*cos(phi)+x1,'Ydata',dy*sin(phi)-dx*cos(phi)+y1,'LineWidth',1);

  dx = [-a;a];
  dy = [h;h]*a;
  set(object.piston,'Xdata',dx*sin(phi)+dy*cos(phi)+x0,'Ydata',dy*sin(phi)-dx*cos(phi)+y0,'LineWidth',1);

  dx = [0;0];
  dy = [h;0]*a;
  set(object.stick,'Xdata',dx*sin(phi)+dy*cos(phi)+x0,'Ydata',dy*sin(phi)+dx*cos(phi)+y0,'LineWidth',1);  
  varargout{1} = 1;
end

%------------------------------------------------------------------
function varargout = springdashpotfun(flag,object,x0,y0,x1,y1,L,h,bs,bc,cc)
% dashpot
switch flag
 case 'init'
  object.spring = springfun('init');
  object.dashpot = dashpotfun('init');
  object.upper =line;
  object.lower = line;
  object.stickl =line;
  object.sticku =line;
  varargout{1} = object;
 case 'draw'
  if x1-x0~=0
   phi = atan((y1-y0)/(x1-x0));
  else
   phi = sign(y1-y0)*pi/2;
  end

  springfun('draw',object.spring,x0-L*sin(phi)+h*cos(phi),y0+L*cos(phi)+h*sin(phi),x1-L*sin(phi)-h*cos(phi),y1+L*cos(phi)-h*sin(phi),bs);
  dashpotfun('draw',object.dashpot,x0+L*sin(phi)+h*cos(phi),y0-L*cos(phi)+h*sin(phi),x1+L*sin(phi)-h*cos(phi),y1-L*cos(phi)-h*sin(phi),bc,cc);
  set(object.upper,'Xdata',[-L;L]*sin(phi)+x0+h*cos(phi),'Ydata',-[-L;L]*cos(phi)+y0+h*sin(phi),'LineWidth',1);
  set(object.lower,'Xdata',[-L;L]*sin(phi)+x1-h*cos(phi),'Ydata',-[-L;L]*cos(phi)+y1-h*sin(phi),'LineWidth',1);
  set(object.stickl,'Xdata',[x0;x0+h*cos(phi)],'Ydata',[y0;y0+h*sin(phi)],'LineWidth',1);
  set(object.sticku,'Xdata',[x1;x1-h*cos(phi)],'Ydata',[y1;y1-h*sin(phi)],'LineWidth',1);
  varargout{1} = [];
end

%------------------------------------------------------------------
function varargout = rspringfun(flag,object,x0,y0,phi,r0,kr,alpha)
% rotational spring
if nargin<6, r0 = 0.15; end
if nargin<7, kr = 0.05; end;
if nargin<8, alpha =1; end;
switch flag
 case 'init'
  varargout{1} = line;
 case 'draw'
  dpsi = pi/24;
  psi = 0:dpsi:(3*pi+phi);
  r = r0+kr*(1-alpha*phi)*psi;
  xdata = -r.*sin(psi) + x0;
  ydata = r.*cos(psi) + y0; 
  set(object,'Xdata',xdata,'Ydata',ydata,'LineWidth',1);  
  varargout{1} = 1;
end

%------------------------------------------------------------------

function varargout = beltfun(flag,object,x0,y0,vdr,t,h,d)
% belt
switch flag
 case 'init'
  object.upper = line;
  object.lower =  line;
  object.rolll =  rectangle;
  object.rollr =  rectangle;
  object.indicatorl = line;
  object.indicatorr = line;  
  varargout{1} = object;
 case 'draw'
  thetadot = vdr/(h/2);
  theta = t*thetadot;
  set(object.upper,'Xdata',[-d d]+x0,'Ydata',[0 0]+y0);
  set(object.lower,'Xdata',[-d d]+x0,'Ydata',[-h -h]+y0);
  set(object.rolll,'Position',[-d-h/2+x0,-h+y0,h,h],'Curvature',[1,1],'FaceColor','b')
  set(object.rollr,'Position',[d-h/2+x0,-h+y0,h,h],'Curvature',[1,1],'FaceColor','b')
  set(object.indicatorl,'Xdata',[-d -d+h/2*cos(theta)]+x0,'Ydata',[-h/2 -h/2+h/2*sin(theta)]+y0);
  set(object.indicatorr,'Xdata',[d d+h/2*cos(theta)]+x0,'Ydata',[-h/2 -h/2+h/2*sin(theta)]+y0);
  varargout{1} = 1;
end
%------------------------------------------------------------------

function varargout = circlefun(flag,object,x0,y0,r,color)
% circle
switch flag
 case 'init'
  object =  rectangle;
  varargout{1} = object;
 case 'draw'
  set(object,'Position',[-r+x0,y0-r,2*r,2*r],'Curvature',[1,1],'FaceColor',color,'Edgecolor','none');
  varargout{1} = 1;
end
%------------------------------------------------------------------

function varargout = earthfun(flag,object,x0,y0,L)
% earth
switch flag
 case 'init'
  object.surface = line;
  object.l1 =  line;
  object.l2 =  line;
  object.l3 =  line;
  object.l4 = line;
  varargout{1} = object;
 case 'draw'
  h=L/2;
  set(object.surface,'Xdata',[-L L]+x0,'Ydata',[0 0]+y0);
  set(object.l1,'Xdata',[-L -L+h]+x0,'Ydata',[0 -h]+y0);
  set(object.l2,'Xdata',[-L+h -L+2*h]+x0,'Ydata',[0 -h]+y0);
  set(object.l3,'Xdata',[-L+2*h -L+3*h]+x0,'Ydata',[0 -h]+y0);
  set(object.l4,'Xdata',[-L+3*h -L+4*h]+x0,'Ydata',[0 -h]+y0);
  varargout{1} = 1;
end

function varargout = ceilingfun(flag,object,x0,y0,L)
% ceiling
switch flag
 case 'init'
  object.surface = line;
  object.l1 =  line;
  object.l2 =  line;
  object.l3 =  line;
  object.l4 = line;
  varargout{1} = object;
 case 'draw'
  h=L/2;
  set(object.surface,'Xdata',[-L L]+x0,'Ydata',[0 0]+y0);
  set(object.l1,'Xdata',[-L -L+h]+x0,'Ydata',[0 h]+y0);
  set(object.l2,'Xdata',[-L+h -L+2*h]+x0,'Ydata',[0 h]+y0);
  set(object.l3,'Xdata',[-L+2*h -L+3*h]+x0,'Ydata',[0 h]+y0);
  set(object.l4,'Xdata',[-L+3*h -L+4*h]+x0,'Ydata',[0 h]+y0);
  varargout{1} = 1;
end
%------------------------------------------------------------------


function varargout = barfun(flag,object,x0,y0,x1,y1)
% bar
switch flag
 case 'init'
  object = line;
  varargout{1} = object;
 case 'draw'
  set(object,'Xdata',[x0,x1],'Ydata',[y0,y1]);
  varargout{1} = 1;
end