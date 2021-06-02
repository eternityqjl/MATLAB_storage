clear all; close all; clc;
t = 0:0.01:3;

%差分函数qdiff的句柄fun1
fun1 = @qdiff;
%将差分函数除以间隔0.01得到范围内的导数值
f11 = fun1(t) / 0.01;
%由于差分结果（导数值）比自变量要少一位，无法输出图像，所以要将自变量改为与
%差分结果相同的数量。
plot(t(:,1:length(f11)), f11)
xlabel('x','Interpreter','LaTex')
ylabel('$\frac{\mathrm{d}f}{\mathrm{d}x}$','Interpreter','LaTex')
title('原函数f的导数')

%原函数qfun的句柄fun2
fun2 = @qfun;
%求原函数在区间[0,3]内的积分q
q = integral(fun2,0,3)

%-----------------------------函数定义--------------------------------%
%定义原函数的差分qdiff
function f1 = qdiff(x)
    fun = @qfun;
    f1 = diff(fun(x));
end

%定义原函数qfun
function f = qfun(x)
    f = 4 - (x-2).*(x-2);
end