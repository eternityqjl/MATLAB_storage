clear all; close all; clc;
%��f��(0.5,0.5,0.5)��������Сֵ��ȷ���ڸõ㸽���Ƿ���ں��������
%vΪ��ʾ�Ա���x,y,z������
v = [0.5,0.5,0.5];
%ʹ��fminsearch������õ㸽������Сֵa
a = fminsearch(@three_var, v)
fmin = three_var(a)
%ʹ��fzero�����ڸõ㸽�������x

%ʹ��fsolve�������
[x2, fval2, exitflag2, output2] = fsolve(@three_var, v)   

%���庯��f
function f = three_var(v)
x = v(1);
y = v(2);
z = v(3);
f = x + (y*y)/(4*x) + (z*z)/y + 2/z;
end

