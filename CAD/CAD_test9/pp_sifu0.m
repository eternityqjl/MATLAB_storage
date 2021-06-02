function [K,kI,x,y,t,x_ss,y_ss,u_ss,zeta_ss]=pp_sifu0(A,b,c,p,v,t)
n=length(A);AA=[A,zeros(n,1);-c,0];bb=[b;0];
KK=acker(AA,bb,p);
K=KK(1:n);%状态反馈增益矩阵
kI=-KK(n+1);%kI为积分增益常数
X=(inv([[A,b];[-c,0]]))*([zeros(n,1);-v]);
x_ss=X(1:n,1);y_ss=c*x_ss;u_ss=X(n+1,1);zeta_ss=([K,1])*X/kI;
[y,x,t]=step([A-b*K,b*kI;-c,0],[zeros(n,1);1],[c,0],0,1,t);

