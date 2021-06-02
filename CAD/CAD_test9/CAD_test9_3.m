clear;clc;
%系统参数
A = [0 20.6;                                    
    1 0];
B = [0; 1];
C = [0 1];

p=[-1.8+2.4*j,-1.8-2.4*j];                    %期望的观测器的极点位置
R1=ctrb(A,B);                                 %求出控制矩阵
R2=obsv(A,C);                                 %求出观测矩阵

if(rank(R1)==length(A)&&rank(R2)==length(A))  %当系统完全可控且可观时
    disp('原系统完全可观可控')                 %配置前声明
    H=(acker(A',C',p))';                      %观测反馈矩阵
    p1=eig(A-H*C);                            %观测反馈矩阵特征值
    p2=p1/3;                                  %状态反馈的极点位置
    K=place(A,B,p2);                          %状态反馈矩阵K
    a=[A -B*K;H*C A-H*C-B*K];                 %添加系统后的系统 
    b=[B;B];                                  %添加后的b
    c=[C 0 0];                                %添加后的c
    te=real(eig(a));                          %特征值的实部
    %判断新系统稳定性
    if sum(te<0)==length(a)                   %如果特征根实部均小于0，系统稳定
        disp('新系统稳定');
    else
        disp('新系统不稳定');
    end
    %判断新系统可控性
    R11=rank(ctrb(a,b));                      %新系统的控制矩阵的秩
    if(R11==length(a))                        %判断可控制性
        disp('新系统完全可控');
    else
        disp('新系统不完全可控');
    end
    %判断新系统可观性
    R22=rank(obsv(a,c));                      %新系统的观测矩阵的秩
    if(R22==length(a))                        %判断可观性
        disp('新系统完全可观');
    else
        disp('新系统不完全可观');
    end
    fprintf('观测矩阵H:[%f,%f]\n',H(1),H(2))  %显示结果H
    fprintf('反馈矩阵K:[%f,%f]\n',K(1),K(2))  %显示结果K
else
    if(rank(R1)~=length(A))                   %判断系统是否完全可控
        disp('该系统不完全可控');
    end 
    if(rank(R2)~=length(A))                   %判断系统是否完全可观
        disp('该系统不完全可观');
    end
    disp('无法实现带有状态观测器的输出反馈系统优化');
end