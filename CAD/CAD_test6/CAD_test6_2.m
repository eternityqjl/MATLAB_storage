clear; clc
%% 状态空间模型的各个矩阵A,B,C,D
A=[0 1 0 0;
   0 0 1 0;
   0 0 0 1;
   -2 -5 -1 -13];
B=[0;0;0;1];
C=[1 0 0 0];
D=0;
sys=ss(A,B,C,D); %系统的状态空间模型
%% 单位阶跃响应
subplot(3,1,1)
step(A,B,C,D)
%% 单位脉冲响应
subplot(3,1,2)
impulse(A,B,C,D)
%% 零输入响应
x0=[2,3,4,5];
subplot(3,1,3)
initial(sys,x0)
%% 系统稳定性
p=eig(A);   %求A矩阵的特征值
if(sum(real(p)>=0)==0)
    disp('系统稳定')
else
    disp('系统不稳定')
end
%% 系统可控性
[n,~]=size(A);           % 求得系统的阶次
Tc=ctrb(A,B);            % 求可控性矩阵
if rank(Tc)==n
    disp('系统能控')
else
    disp('系统不能控')
end
%% 系统可观性
To=obsv(A,C);          % 求可观性矩阵
if(rank(To)==n)
    disp('系统能观')
else
    disp('系统不能观')
end