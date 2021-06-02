clear;clc

Pm = 50;                                    %�������ԣ��
ng0 = 1;                                    %ԭϵͳ�������ݺ�������
dg0 = conv([1,0,0],[1,5]);                  %ԭϵͳ�������ݺ�����ĸ
g0 = tf(ng0,dg0);   %ԭϵͳ�Ŀ������ݺ���
t = [0:0.01:30];                            %ʱ��Χ
w = logspace(-3,3);                         %Ƶ��Χ
[ngc,dgc] = fg_lead_pm(ng0,dg0,Pm,w)        %���У��װ�õĴ�����ngcΪ����ϵ����dgcΪ��ĸϵ��
gc = tf(ngc,dgc),g0c=tf(g0*gc) %У��װ�õĴ��ݺ�����У����ϵͳ�Ĵ��ݺ���
b1=feedback(g0,1); b2=feedback(g0c,1);  %���и������Ĵ��ݺ���

step(b1,'r--', b2,'b',t); grid on  %��Ծ��Ӧ���ߣ�У��ǰb1��У����b2
legend({'g0: ԭϵͳ','g0c: У�����ϵͳ'},'Location','southwest')

figure, bode(g0,'r--',g0c,'b',w), grid on,  %ԭϵͳ��У����ϵͳ�Ĳ���ͼ�Ƚ�ͼ
legend({'g0: ԭϵͳ','g0c: У�����ϵͳ'},'Location','southwest')
[gm,pm,wcg,wcp]=margin(g0c), Km=20*log10(gm)    %����У����ϵͳ�ĸ����������ֱ�Ϊ����ԣ�ȡ���λԣ�ȡ��ഩƵ�ʡ�����Ƶ��

[Mr, wr] = getPeakGain(b2)  %г���ֵ��г���Ƶ��

figure;
margin(g0c) %У����ϵͳ�Ĳ���ͼ

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