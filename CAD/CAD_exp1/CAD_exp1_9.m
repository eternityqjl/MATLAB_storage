clear all; close all; clc;
%ȷ���Ա���x��ȡֵ��Χ
x=0:0.01:5;
%��ͼ
fun1 = @fun0;
plot(x,fun1(x))
title('$y = x e^{-3x}$','Interpreter','LaTex')
xlabel('$x$','Interpreter','LaTex')
ylabel('$y$','Interpreter','LaTex')
grid on

%������ֵ����q1(ʹ��vpa�������þ���)
q1 = vpa(integral(fun1,0,5),20)

%������Ż���q2(ʹ��vpa�������þ���)
syms x
y = x.*exp(-3*x);
q2 = vpa(int(y,0,5),20)

%������бȽ�
result = abs(q1 - q2)

%���庯��y=x.*exp(-3*x)
function y = fun0(x)
    y = x.*exp(-3*x);
end