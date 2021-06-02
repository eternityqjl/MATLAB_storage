clear; clc
%% 状态空间模型的各个矩阵A,B,C,D
A=[0 1 0 0;
   0 0 1 0;
   0 0 0 1;
   -2 -5 -1 -13];
B=[0;0;0;1];
C=[1 0 0 0];
D=0;
%% 构建系统的状态空间模型
sys=ss(A,B,C,D)         
%% 转为传递函数模型
gtf=tf(sys)             
%% 转为zpk模型
gzpk=zpk(sys)           
%% 模型属性
% ss对象的属性A,B,C,D
get(sys)                                          %获取模型详细信息                                       
[A1,B1,C1,D1]=ssdata(sys,'cell')       %在工作区显示模型主要属性
% tf对象的属性num,den
get(gtf)                                          %获取模型详细信息  
[num,den]=tfdata(gtf,'v')                %在工作区显示模型主要属性
% zpk对象的属性z,p,k
get(gzpk)                                       %获取模型详细信息  
[z,p,k]=zpkdata(gzpk,'v')                 %在工作区显示模型主要属性