function F = funnel_anim(sys,t,q,aviname)
% funnel_anim.m: animation file for sys_funnel.m
%
% Remco Leine

scaling = 1;
midxpos = 12;
midypos = -10;

a = scaling*sys.a;
R = scaling*sys.R;
R0 = scaling*sys.R0;
x_left = scaling*sys.x_left + midxpos;
y_left = scaling*sys.y_left + midypos;
x_right = scaling*sys.x_right + midxpos;
y_right = scaling*sys.y_right + midypos;


q = scaling*q;
q(1:sys.n,:) = q(1:sys.n,:)  + midxpos;
q(sys.n+1:end,:) = q(sys.n+1:end,:)  + midypos;

if nargin<4, aviname = 'test.avi'; end
if nargin<5, antialias = false; end

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

gray = [.7 .7 .7];

v = VideoWriter(aviname);
open(v);

set(gca,'xlim',[-5 30],'ylim',[-15 10],'nextplot','replacechildren','Visible','off');

support_left = circlefun('init');
support_right =  circlefun('init');
for j = 1:sys.n
  balls(j) =  circlefun('init');
end 

time = text(0,-5,'t = 0');
circlefun('draw',support_left,x_left,y_left,R0,gray);
circlefun('draw',support_right,x_right,y_right,R0,gray);

for i=1:K:N;  
    x = q(1:sys.n,i);
    y = q(sys.n+1:end,i);
 
    for j = 1:sys.n
        circlefun('draw',balls(j),x(j),y(j),R,'r');
    end    
 
    set(time,'String',['t = ',num2str(t(i))]);
 
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