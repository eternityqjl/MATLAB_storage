clear all; close all; clc;

%%
%使用dsolve计算微分方程的符号解
%syms y(t);
ySol=dsolve('Dy=1+y^2', 'y(0)=1');

%作出图像
subplot(1,2,1)
fplot(ySol)
title('符号解')
xlabel('$t$','Interpreter','LaTex')
ylabel('$y(t)$','Interpreter','LaTex')
axis([0 10,-10 10]) %设定x轴和y轴的范围
hold on 

%%
%使用ode45函数计算微分方程的数值解
%直接在[0,10]的范围内计算无法获得间断点附近的结果，因此需要分段求解
[t0,y0]=ode45(@fun0,[0,pi./4+0.01],1);
[t1,y1]=ode45(@fun0,[pi./4+0.01,pi.*(5/4)-0.01],-10);
[t2,y2]=ode45(@fun0,[pi.*(5/4)+0.01,pi.*(9/4)-0.01],-10);
[t3,y3]=ode45(@fun0,[pi.*(9/4)+0.01,pi.*(13/4)-0.01],-10);

%作出图像
subplot(1,2,2)
plot(t0,y0,t1,y1,t2,y2,t3,y3)
title('数值解')
xlabel('$t$','Interpreter','LaTex')
ylabel('$y(t)$','Interpreter','LaTex')
axis([0 10,-10 10]) %设定x轴和y轴的范围
hold on

%%
%定义初始微分方程对应的函数fun0
function dy = fun0(t,y)
    dy = 0;
    dy(1) = 1+y(1)^2;
end
