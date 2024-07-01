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
v.Quality=100;
v.FrameRate = 40;
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

