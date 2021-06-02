clear all; close all; clc;

%%
%ʹ��dsolve����΢�ַ��̵ķ��Ž�
%syms y(t);
ySol=dsolve('Dy=1+y^2', 'y(0)=1');

%����ͼ��
subplot(1,2,1)
fplot(ySol)
title('���Ž�')
xlabel('$t$','Interpreter','LaTex')
ylabel('$y(t)$','Interpreter','LaTex')
axis([0 10,-10 10]) %�趨x���y��ķ�Χ
hold on 

%%
%ʹ��ode45��������΢�ַ��̵���ֵ��
%ֱ����[0,10]�ķ�Χ�ڼ����޷���ü�ϵ㸽���Ľ���������Ҫ�ֶ����
[t0,y0]=ode45(@fun0,[0,pi./4+0.01],1);
[t1,y1]=ode45(@fun0,[pi./4+0.01,pi.*(5/4)-0.01],-10);
[t2,y2]=ode45(@fun0,[pi.*(5/4)+0.01,pi.*(9/4)-0.01],-10);
[t3,y3]=ode45(@fun0,[pi.*(9/4)+0.01,pi.*(13/4)-0.01],-10);

%����ͼ��
subplot(1,2,2)
plot(t0,y0,t1,y1,t2,y2,t3,y3)
title('��ֵ��')
xlabel('$t$','Interpreter','LaTex')
ylabel('$y(t)$','Interpreter','LaTex')
axis([0 10,-10 10]) %�趨x���y��ķ�Χ
hold on

%%
%�����ʼ΢�ַ��̶�Ӧ�ĺ���fun0
function dy = fun0(t,y)
    dy = 0;
    dy(1) = 1+y(1)^2;
end
