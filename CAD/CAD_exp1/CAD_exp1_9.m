clear all; close all; clc;
%确定自变量x的取值范围
x=0:0.01:5;
%作图
fun1 = @fun0;
plot(x,fun1(x))
title('$y = x e^{-3x}$','Interpreter','LaTex')
xlabel('$x$','Interpreter','LaTex')
ylabel('$y$','Interpreter','LaTex')
grid on

%计算数值积分q1(使用vpa函数设置精度)
q1 = vpa(integral(fun1,0,5),20)

%计算符号积分q2(使用vpa函数设置精度)
syms x
y = x.*exp(-3*x);
q2 = vpa(int(y,0,5),20)

%作差进行比较
result = abs(q1 - q2)

%定义函数y=x.*exp(-3*x)
function y = fun0(x)
    y = x.*exp(-3*x);
end