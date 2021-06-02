clear all; close all; clc;

%�����������
tspan = [0,1];
%��ֵ����
y0 = 2;
%΢�ַ���
ode = @(t, y) (y*y-t-2)/(4*(t+1));
%ʹ��ode45������������
[t, y] = ode45(ode, tspan, y0);

%��ȷ��ı�ʾ
t1 = 0:0.1:1;
y1 = sqrt(t1 + 1) + 1;

%�����߻���ͬһ��ͼ�бȽϣ����Կ��������ǳ�С
plot(t,y, t1, y1)
xlabel('t','Interpreter','LaTex')
ylabel('$y(t)$','Interpreter','LaTex')
title('΢�ַ��̵������')
