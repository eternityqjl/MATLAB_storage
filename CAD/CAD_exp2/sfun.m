function [sys,x0,str,ts]=sfun(t,x,u,flag,m0,m1,m2,j1,j2,l1,l2,l,f0,f1,f2,g0,g)
switch flag
    case 0                      %��ʼ��
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1                      %��������״̬
        sys=mdlDerivatives(t,x,u,m0,m1,m2,j1,j2,l1,l2,l,f0,f1,f2,g0,g);
    case 2                      %������ɢ״̬
        sys=mdlUpdate(t,x,u);
    case 3                      %�������
        sys=mdlOutputs(t,x,u);
    case 4                      %�������ʱ��
        sys=mdlGetTimeOfNextVarHit(t,x,u);
    case 9                      %����ʱ�Ķ���
        sys=mdlTerminate(t,x,u);
    otherwise                   %flag����
        error(['����ȷ��flag=',num2str(flag)]);
end

%��ʼ��
function [sys,x0,str,ts]=mdlInitializeSizes()
    sizes=simsizes;             %�����ߴ�ṹ
    sizes.NumContStates = 6;    %����״̬�ĸ���Ϊ0
    sizes.NumDiscStates = 0;    %��ɢ״̬�ĸ���Ϊ0
    sizes.NumOutputs    = 6;    %�������Ϊ1
    sizes.NumInputs     = 1;    %�������Ϊ2
    sizes.DirFeedthrough= 0;    %ֱ�ӷ�������
    sizes.NumSampleTimes= 1;    %������һ������ʱ��
    sys = simsizes(sizes);
    x0                  = [0 0 0 0 0 0];   %��״̬,�ʳ�ʼ״̬Ϊ��
    str                 = [];   %ϵͳ����
    ts                  = [0 0];%��ʼ������ʱ������
    
    
function sys=mdlDerivatives(t,x,u,m0,m1,m2,j1,j2,l1,l2,l,f0,f1,f2,g0,g)
%��������״̬
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
%����ɢ״̬
    sys =[];

function sys=mdlOutputs(t,x,u)
%�������
    sys = x;

function sys=mdlGetTimeOfNextVarHit(t,x,u)
%�������ʱ��
    sampleTime = 1;

function sys=mdlTerminate(t,x,u)
%����ʱ�Ķ���
    sys = [];
