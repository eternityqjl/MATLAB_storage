function [sys,x0,str,ts]=sfun(t,x,u,flag,m0,m1,m2,j1,j2,l1,l2,l,f0,f1,f2,g0,g)
switch flag
    case 0                      %初始化
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1                      %计算连续状态
        sys=mdlDerivatives(t,x,u,m0,m1,m2,j1,j2,l1,l2,l,f0,f1,f2,g0,g);
    case 2                      %计算离散状态
        sys=mdlUpdate(t,x,u);
    case 3                      %计算输出
        sys=mdlOutputs(t,x,u);
    case 4                      %计算采样时间
        sys=mdlGetTimeOfNextVarHit(t,x,u);
    case 9                      %结束时的动作
        sys=mdlTerminate(t,x,u);
    otherwise                   %flag错误
        error(['不正确的flag=',num2str(flag)]);
end

%初始化
function [sys,x0,str,ts]=mdlInitializeSizes()
    sizes=simsizes;             %创建尺寸结构
    sizes.NumContStates = 6;    %连续状态的个数为0
    sizes.NumDiscStates = 0;    %离散状态的个数为0
    sizes.NumOutputs    = 6;    %输出个数为1
    sizes.NumInputs     = 1;    %输入个数为2
    sizes.DirFeedthrough= 0;    %直接反馈输入
    sizes.NumSampleTimes= 1;    %至少需一个采样时间
    sys = simsizes(sizes);
    x0                  = [0 0 0 0 0 0];   %无状态,故初始状态为空
    str                 = [];   %系统保留
    ts                  = [0 0];%初始化采样时间数组
    
    
function sys=mdlDerivatives(t,x,u,m0,m1,m2,j1,j2,l1,l2,l,f0,f1,f2,g0,g)
%计算连续状态
    Mass = [    m0+m1+m2,                   (m1*l1+m2*l)*cos(x(2)),     m2*l2*cos(x(3));
                (m1*l1+m2*l)*cos(x(2)),     j1+m1*l1^2+m2*l^2,          m2*l1*l*cos(x(3)-x(2));
                m2*l2*cos(x(3)),            m2*l2*l*cos(x(3)-x(2)),     j2+m2*l2^2
           ];
       
    F = [       -f0,	(m1*l1+m2*l)*sin(x(2))*x(5),        m2*l2*sin(x(2))*x(6);
                0,      -(f1+f2),                           f2+m2*l2*l*sin(x(3)-x(2))*x(6);
                0,      -m2*l2*l*sin(x(3)-x(2))*x(6)+f2,	-f2
        ] ;  
    
    N = [       u;      (m1*l1+m2*l)*g*sin(x(2));       m2*l2*g*sin(x(3))	];
    
    G = [g0; 0; 0];
    %x'
    sys = [zeros(3), eye(3); zeros(3), inv(Mass)*F] * x + [zeros(3,1); inv(Mass)*N] + [zeros(3,1); inv(Mass)*G]*u;

    
function sys=mdlUpdate(t,x,u)
%无离散状态
    sys =[];

function sys=mdlOutputs(t,x,u)
%计算输出
    sys = x;

function sys=mdlGetTimeOfNextVarHit(t,x,u)
%计算采样时间
    sampleTime = 1;

function sys=mdlTerminate(t,x,u)
%结束时的动作
    sys = [];
