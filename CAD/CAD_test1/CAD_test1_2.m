clear all; close all; clc;

t = 0:0.01:6;

fun = @q;
%根据图像的大概范围求原函数f的两个零点
x1 = fzero(fun, [0.01,1.5])
x2 = fzero(fun, [1.5,5])

fun1 = @q1;
%使用fminunc求得-f(t)的最小值点(x,fmin)
[x, fmin] = fminunc(fun1,0.5)
%加符号即为f(t)的最大值
fmax = -fmin

%画图并在图中标注出零点和最大值点
plot(t, fun(t),x1,0,'-o',x2,0,'-o',x,fmax,'-o')
text(x1,0,'\leftarrow zero1')
text(x2,0,'\leftarrow zero2')
text(x,fmax,'\leftarrow max')
title('f(t)在t>0的曲线')
xlabel('t','Interpreter','LaTex')
ylabel('f(t)','Interpreter','LaTex')

%原函数f(t)
function f = q(t);
f = power(sin(t), 2) .* exp(-0.1*t) - 0.5*abs(t);
end
%函数-f(t)
function f1 = q1(t);
f1 = -(power(sin(t), 2) .* exp(-0.1*t) - 0.5*abs(t));
end
