function [sys,x0,str,ts]=sfun(t,x,u,flag)
switch flag
    case 0                      %��ʼ��
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1                      %��������״̬
        sys=mdlDerivatives(t,x,u);
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
    sizes.NumContStates = 2;    %����״̬�ĸ���Ϊ0
    sizes.NumDiscStates = 0;    %��ɢ״̬�ĸ���Ϊ0
    sizes.NumOutputs    = 1;    %�������Ϊ1
    sizes.NumInputs     = 1;    %�������Ϊ2
    sizes.DirFeedthrough= 0;    %ֱ�ӷ�������
    sizes.NumSampleTimes= 1;    %������һ������ʱ��
    sys = simsizes(sizes);
    x0                  = [0 0];   %��״̬,�ʳ�ʼ״̬Ϊ��
    str                 = [];   %ϵͳ����
    ts                  = [0 0];%��ʼ������ʱ������
    
    
function sys=mdlDerivatives(t,x,u)
%��������״̬
    y1=0*x(1)+1*x(2)+0*u;
    y2=-0.4*x(1)-0.2*x(2)+0.2*u;
    sys =[y1;y2];
    
function sys=mdlUpdate(t,x,u)
%����ɢ״̬
    sys =[];

function sys=mdlOutputs(t,x,u)
%�������
    sys = x(1);

function sys=mdlGetTimeOfNextVarHit(t,x,u)
%�������ʱ��
    sampleTime = 1;

function sys=mdlTerminate(t,x,u)
%����ʱ�Ķ���
    sys = [];
