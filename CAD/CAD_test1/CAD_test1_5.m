clear all; close all; clc;

%设置求解区间
tspan = [0,1];
%初值条件
y0 = 2;
%微分方程
ode = @(t, y) (y*y-t-2)/(4*(t+1));
%使用ode45求解器进行求解
[t, y] = ode45(ode, tspan, y0);

%精确解的表示
t1 = 0:0.1:1;
y1 = sqrt(t1 + 1) + 1;

%将二者画在同一幅图中比较，可以看出，误差非常小
plot(t,y, t1, y1)
xlabel('t','Interpreter','LaTex')
ylabel('$y(t)$','Interpreter','LaTex')
title('微分方程的求解结果')
