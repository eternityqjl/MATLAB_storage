clear all; close all; clc;
%求f在(0.5,0.5,0.5)附近的最小值，确定在该点附近是否存在函数的零点
%v为表示自变量x,y,z的向量
v = [0.5,0.5,0.5];
%使用fminsearch函数求该点附近的最小值a
a = fminsearch(@three_var, v)
fmin = three_var(a)
%使用fzero求函数在该点附近的零点x

%使用fsolve求函数零点
[x2, fval2, exitflag2, output2] = fsolve(@three_var, v)   

%定义函数f
function f = three_var(v)
x = v(1);
y = v(2);
z = v(3);
f = x + (y*y)/(4*x) + (z*z)/y + 2/z;
end

