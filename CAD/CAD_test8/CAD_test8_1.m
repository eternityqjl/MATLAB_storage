clear;clc

Pm = 50;                                    %期望相角裕度
ng0 = 1;                                    %原系统开环传递函数分子
dg0 = conv([1,0,0],[1,5]);                  %原系统开环传递函数分母
g0 = tf(ng0,dg0);   %原系统的开环传递函数
t = [0:0.01:30];                            %时域范围
w = logspace(-3,3);                         %频域范围
[ngc,dgc] = fg_lead_pm(ng0,dg0,Pm,w)        %求得校正装置的传函，ngc为分子系数，dgc为分母系数
gc = tf(ngc,dgc),g0c=tf(g0*gc) %校正装置的传递函数、校正后系统的传递函数
b1=feedback(g0,1); b2=feedback(g0c,1);  %带有负反馈的传递函数

step(b1,'r--', b2,'b',t); grid on  %阶跃响应曲线，校正前b1和校正后b2
legend({'g0: 原系统','g0c: 校正后的系统'},'Location','southwest')

figure, bode(g0,'r--',g0c,'b',w), grid on,  %原系统和校正后系统的伯德图比较图
legend({'g0: 原系统','g0c: 校正后的系统'},'Location','southwest')
[gm,pm,wcg,wcp]=margin(g0c), Km=20*log10(gm)    %计算校正后系统的各个参数，分别为增益裕度、相位裕度、相穿频率、幅穿频率

[Mr, wr] = getPeakGain(b2)  %谐振峰值、谐振角频率

figure;
margin(g0c) %校正后系统的伯德图

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