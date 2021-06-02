clear all; close all; clc;
t = 0:0.01:3;

%��ֺ���qdiff�ľ��fun1
fun1 = @qdiff;
%����ֺ������Լ��0.01�õ���Χ�ڵĵ���ֵ
f11 = fun1(t) / 0.01;
%���ڲ�ֽ��������ֵ�����Ա���Ҫ��һλ���޷����ͼ������Ҫ���Ա�����Ϊ��
%��ֽ����ͬ��������
plot(t(:,1:length(f11)), f11)
xlabel('x','Interpreter','LaTex')
ylabel('$\frac{\mathrm{d}f}{\mathrm{d}x}$','Interpreter','LaTex')
title('ԭ����f�ĵ���')

%ԭ����qfun�ľ��fun2
fun2 = @qfun;
%��ԭ����������[0,3]�ڵĻ���q
q = integral(fun2,0,3)

%-----------------------------��������--------------------------------%
%����ԭ�����Ĳ��qdiff
function f1 = qdiff(x)
    fun = @qfun;
    f1 = diff(fun(x));
end

%����ԭ����qfun
function f = qfun(x)
    f = 4 - (x-2).*(x-2);
end