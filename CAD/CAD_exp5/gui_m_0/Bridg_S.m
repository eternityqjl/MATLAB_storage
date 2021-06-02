% 	桥式吊车非线性动力学模型
% 	参数意义
% 	Dm		吊车质量(Kg)
% 	Wm		物体质量(Kg)
% 	l		绳子长度
% 	K		驱动电压放大倍数
% 	Td		电机时间常数
% 	g		重力加速度
%   X0      预设的水平位置
% 	x(1)	吊车位移
% 	x(2)	吊车速度
% 	x(3)	绳子与竖直角度
% 	x(4)	绳子末端角速度
% 	x(5)	吊车所受水平拉力
function [sys,x0,str,ts]=Bridg_S(t,x,u,flag,Dm,Wm,l,K,Td,g,X_0)
switch flag
    case 0                                       % 初始化
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1                                       % 计算连续状态
        if(x(1)>=X_0)                            % 当位置到达预定的位置的时候，设置各参量数值
            x(1)=X_0;                            % 将吊车位置固定在预定位置
            x(2)=0;                              % 将吊车速度置为零
            x(3)=0.1*x(3);                       % 将绳子角度的衰减值设置为0.1
            x(4)=0.1*x(4);                       % 将绳子角速度衰减值设置为0.1
            x(5)=0;                              % 将驱动力设置为0
        end
        sys=mdlDerivatives(t,x,u,Dm,Wm,l,K,Td,g);
    case 2                                      % 计算离散状态
        sys=mdlUpdate(t,x,u);
    case 3                                      % 计算输出
        sys=mdlOutputs(t,x,u,X_0);
    case 4                                      % 计算采样时间
        sys=mdlGetTimeOfNextVarHit(t,x,u);
    case 9                                      % 结束时的动作
        sys=mdlTerminate(t,x,u);
    otherwise                                   % flag错误
        error(['不正确的flag=',num2str(flag)]);
end



function [sys,x0,str,ts]=mdlInitializeSizes()
    sizes=simsizes;                             % 创建尺寸结构
    sizes.NumContStates = 5;                    % 连续状态的个数为5
    sizes.NumDiscStates = 0;                    % 离散状态的个数为0
    sizes.NumOutputs    = 5;                    % 输出个数为5
    sizes.NumInputs     = 1;                    % 输入个数为1
    sizes.DirFeedthrough= 0;                    % 无直接反馈输入
    sizes.NumSampleTimes= 1;                    % 至少需一个采样时间
    sys = simsizes(sizes);
    x0                  = zeros(5,1);           % 初始为零状态 
    str                 = [];               	% 系统保留
    ts                  = [0 0];            	% 初始化采样时间数组
    
function sys=mdlDerivatives(t,x,u,Dm,Wm,l,K,Td,g)
                                                % 连续状态转移方程
    Ma=[1   0   0   0   0  ;   0 Dm+Wm 0     -Wm*l*cos(x(3)) 0 ;0    0   1  0   0;
        0  cos(x(3)) 0 -l   0;   0   0   0   0  l];
    Mb=[0 1 0 0 0 ;0 0 0 -Wm*sin(x(3))*x(4) 1 ; 0 0 0 1 0 ;0 0 0 0 0 ;0 0 0 0 -1/Td];
    MB=[0;0;0;g*sin(x(3));0];
    MD=[0;0;0;0;K/Td];                          % 输入各状态矩阵
    sys=inv(Ma)*Mb*x+inv(Ma)*(MB)+inv(Ma)*MD*u;
                                                % 得到当前状态的值
        
function sys=mdlUpdate(t,x,u)                   %无离散状态      
    sys = [];

function sys=mdlOutputs(t,x,u,X_0)
                                                % 系统输出为所有状态
    if(x(1)>=X_0)                               % 当位置到达预定的位置的时候，设置各参量数值
        x(1)=X_0;                               % 将吊车位置固定在预定位置
        x(2)=0;                                 % 将吊车速度置为零
        x(3)=0.1*x(3);                          % 将绳子角度的衰减值设置为0.1
        x(4)=0.1*x(4);                          % 将绳子角速度衰减值设置为0.1
        x(5)=0;                                 % 将驱动力设置为0
    end
    sys = x;                                    % 输出各状态变量

function sys=mdlGetTimeOfNextVarHit(t,x,u)
    sampleTime = [];

function sys=mdlTerminate(t,x,u)
    sys = []; 
    
    