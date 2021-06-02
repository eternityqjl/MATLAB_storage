clc; clear
A=[1  1  0;
   1 -1  0;
   0  1  3];
B=[1;0;0]; C=[1 0 1]; D=0;
H=A*B; E=A*A*B; F=[B H E];
rank(F)                         %可观性判别阵Qc的秩
[num, den]=ss2tf(A,B,C,D);
G=tf(num,den)                   %系统的传递函数G
P=[-2+1j*3, -2-1j*3, -1];
K=acker(A,B,P)                  %状态反馈矩阵K
rlocus(G)