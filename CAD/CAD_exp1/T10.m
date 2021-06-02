%%
clc
clear
yS = dsolve('Dy=1+y^2','y(0)=1');
%t = 0:0.01:10;
%y = eval(subs(yS));
subplot(1,2,1)
fplot(yS)
axis([0 10,-10 10])
hold on 
%%
syms t
zz1=limit(yS,t,pi/4,'left');
zz2=limit(yS,t,pi/4,'right');
if(zz1~=zz2)                   % 不等于的表示方法
    fprintf('在t=pi/4处不可导\n');
end

zz1=limit(yS,t,5*pi/4,'left');
zz2=limit(yS,t,5*pi/4,'right');
if(zz1~=zz2)                   % 不等于的表示方法
    fprintf('在t=5*pi/4处不可导\n');
end

zz1=limit(yS,t,9*pi/4,'left');
zz2=limit(yS,t,9*pi/4,'right');
if(zz1~=zz2)                   % 不等于的表示方法
    fprintf('在t=9*pi/4处不可导\n');
end
%%
y0 = 1;
tspan = [0,pi/4+0.684];
[T1,Y1] = ode45( @odefun, tspan, y0 );
tspan = [pi/4+0.1,pi/4+pi-0.1];
[T2,Y2] = ode45( @odefun, tspan, -10 );
tspan = [5*pi/4+0.1,5*pi/4+pi-0.1];
[T3,Y3] = ode45( @odefun, tspan, -10 );
tspan = [9*pi/4+0.1,9*pi/4+pi-0.1];
[T4,Y4] = ode45( @odefun, tspan, -10 );
subplot(1,2,2)
plot(T1,Y1)
hold on ;
plot(T2,Y2)
plot(T3,Y3)
plot(T4,Y4)

axis([0 10,-10 10])
%plot(T,Y,'.')
%%
function dy = odefun(t,y)
dy = zeros(1,1);
dy(1) = 1+y(1)^2;
end