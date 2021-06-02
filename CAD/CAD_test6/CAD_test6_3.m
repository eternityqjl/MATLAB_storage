clear; clc

%% 将simulink模型线性化，得到状态空间模型
[A,B,C,D]=linmod('CAD_test6_3_sim')
%% 构建系统的状态空间模型
sys=ss(A,B,C,D)  
%% 转为传递函数模型
gtf=tf(sys)  
%% 通过zpk模型求得零极点
gzpk=zpk(sys);
get(gzpk);                                    %获取模型详细信息  
[z,p]=zpkdata(gzpk,'v')                 %在工作区显示模型主要属性
%% 系统稳定性
p=eig(A);   %求A矩阵的特征值
if(sum(real(p)>=0)==0)
    disp('系统稳定')
else
    disp('系统不稳定')
end
%% 单位阶跃响应
step(A,B,C,D)