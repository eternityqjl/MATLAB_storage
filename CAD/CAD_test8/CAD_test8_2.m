clear; clc
kk = 40;
ng0=[1];    %ԭϵͳ�����������ӡ���ĸϵ��
dg0=conv([1,0],conv([1,1],[1,4]));
t=[0:0.01:5]; w=logspace(-3,2); %ʱ��Ƶ��Χ
g0=tf(ng0,dg0)  %ԭϵͳ���ݺ���
[gm0,pm0,wcg0,wcp0]=margin(g0)  %ԭϵͳ����: ����ԣ�ȡ���λԣ�ȡ��ഩƵ�ʡ�����Ƶ��
km0=20*log(gm0)
Pm=50;
[ng1,dg1]=fg_lead_pm(kk*ng0, dg0, Pm, w);
g1=tf(ng1,dg1); %У��װ�ô��ݺ���
g2=kk*g1*g0;    %У�����ϵͳ
[gm1,pm1,wcg1,wcp1]=margin(g2)  %У����ϵͳ�Ĳ���
km1=20*log(gm1)
bode(kk*g0,'r--',g1,'b--',g2,'g',w), grid on;
legend({'g0: ԭϵͳ','g1: У��װ��', 'g2: У�����ϵͳ'},'Location','southwest')

function [ngc, dgc] = fg_lead_pm(ng0, dg0, Pm, w)
%��У��װ��ϵ��
    [mu, pu]=bode(ng0, dg0, w);
    [gm, pm, wcg, wcp]=margin(mu,pu,w); %the gain and phase margins on the plot
    alf=ceil(Pm-pm+5);  %��ǰװ����Ҫ�ṩ�ĳ�ǰ�ǵĽǶ���������������
    phi = (alf)*pi/180; %���Ƕ���ת��Ϊ������
    a = (1+sin(phi))/(1-sin(phi));  %��ǰУ��ϵ��
    a1 = 1/a;
    dbmu = 20*log10(mu);
    mm=-10*log10(a);
    wgc=spline(dbmu,w,mm);  %���η��������ݲ�ֵ
    T=1/(wgc*sqrt(a));
    ngc=[a*T,1];dgc=[T,1];
end