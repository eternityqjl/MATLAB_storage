clear; clc
kk = 40;
ng0=[1];    %原系统开环传函分子、父母系数
dg0=conv([1,0],conv([1,1],[1,4]));
t=[0:0.01:5]; w=logspace(-3,2); %时域、频域范围
g0=tf(ng0,dg0)  %原系统传递函数
[gm0,pm0,wcg0,wcp0]=margin(g0)  %原系统参数: 增益裕度、相位裕度、相穿频率、幅穿频率
km0=20*log(gm0)
Pm=50;
[ng1,dg1]=fg_lead_pm(kk*ng0, dg0, Pm, w);
g1=tf(ng1,dg1); %校正装置传递函数
g2=kk*g1*g0;    %校正后的系统
[gm1,pm1,wcg1,wcp1]=margin(g2)  %校正后系统的参数
km1=20*log(gm1)
bode(kk*g0,'r--',g1,'b--',g2,'g',w), grid on;
legend({'g0: 原系统','g1: 校正装置', 'g2: 校正后的系统'},'Location','southwest')

function [ngc, dgc] = fg_lead_pm(ng0, dg0, Pm, w)
%求校正装置系数
    [mu, pu]=bode(ng0, dg0, w);
    [gm, pm, wcg, wcp]=margin(mu,pu,w); %the gain and phase margins on the plot
    alf=ceil(Pm-pm+5);  %求超前装置需要提供的超前角的角度数，并四舍五入
    phi = (alf)*pi/180; %将角度数转换为弧度数
    a = (1+sin(phi))/(1-sin(phi));  %求超前校正系数
    a1 = 1/a;
    dbmu = 20*log10(mu);
    mm=-10*log10(a);
    wgc=spline(dbmu,w,mm);  %三次方样条数据插值
    T=1/(wgc*sqrt(a));
    ngc=[a*T,1];dgc=[T,1];
end