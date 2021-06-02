clear all; close all; clc;

t = 0:0.01:6;

fun = @q;
%����ͼ��Ĵ�ŷ�Χ��ԭ����f���������
x1 = fzero(fun, [0.01,1.5])
x2 = fzero(fun, [1.5,5])

fun1 = @q1;
%ʹ��fminunc���-f(t)����Сֵ��(x,fmin)
[x, fmin] = fminunc(fun1,0.5)
%�ӷ��ż�Ϊf(t)�����ֵ
fmax = -fmin

%��ͼ����ͼ�б�ע���������ֵ��
plot(t, fun(t),x1,0,'-o',x2,0,'-o',x,fmax,'-o')
text(x1,0,'\leftarrow zero1')
text(x2,0,'\leftarrow zero2')
text(x,fmax,'\leftarrow max')
title('f(t)��t>0������')
xlabel('t','Interpreter','LaTex')
ylabel('f(t)','Interpreter','LaTex')

%ԭ����f(t)
function f = q(t);
f = power(sin(t), 2) .* exp(-0.1*t) - 0.5*abs(t);
end
%����-f(t)
function f1 = q1(t);
f1 = -(power(sin(t), 2) .* exp(-0.1*t) - 0.5*abs(t));
end
