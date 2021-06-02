% 	��ʽ���������Զ���ѧģ��
% 	��������
% 	Dm		��������(Kg)
% 	Wm		��������(Kg)
% 	l		���ӳ���
% 	K		������ѹ�Ŵ���
% 	Td		���ʱ�䳣��
% 	g		�������ٶ�
%   X0      Ԥ���ˮƽλ��
% 	x(1)	����λ��
% 	x(2)	�����ٶ�
% 	x(3)	��������ֱ�Ƕ�
% 	x(4)	����ĩ�˽��ٶ�
% 	x(5)	��������ˮƽ����
function [sys,x0,str,ts]=Bridg_S(t,x,u,flag,Dm,Wm,l,K,Td,g,X_0)
switch flag
    case 0                                       % ��ʼ��
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1                                       % ��������״̬
        if(x(1)>=X_0)                            % ��λ�õ���Ԥ����λ�õ�ʱ�����ø�������ֵ
            x(1)=X_0;                            % ������λ�ù̶���Ԥ��λ��
            x(2)=0;                              % �������ٶ���Ϊ��
            x(3)=0.1*x(3);                       % �����ӽǶȵ�˥��ֵ����Ϊ0.1
            x(4)=0.1*x(4);                       % �����ӽ��ٶ�˥��ֵ����Ϊ0.1
            x(5)=0;                              % ������������Ϊ0
        end
        sys=mdlDerivatives(t,x,u,Dm,Wm,l,K,Td,g);
    case 2                                      % ������ɢ״̬
        sys=mdlUpdate(t,x,u);
    case 3                                      % �������
        sys=mdlOutputs(t,x,u,X_0);
    case 4                                      % �������ʱ��
        sys=mdlGetTimeOfNextVarHit(t,x,u);
    case 9                                      % ����ʱ�Ķ���
        sys=mdlTerminate(t,x,u);
    otherwise                                   % flag����
        error(['����ȷ��flag=',num2str(flag)]);
end



function [sys,x0,str,ts]=mdlInitializeSizes()
    sizes=simsizes;                             % �����ߴ�ṹ
    sizes.NumContStates = 5;                    % ����״̬�ĸ���Ϊ5
    sizes.NumDiscStates = 0;                    % ��ɢ״̬�ĸ���Ϊ0
    sizes.NumOutputs    = 5;                    % �������Ϊ5
    sizes.NumInputs     = 1;                    % �������Ϊ1
    sizes.DirFeedthrough= 0;                    % ��ֱ�ӷ�������
    sizes.NumSampleTimes= 1;                    % ������һ������ʱ��
    sys = simsizes(sizes);
    x0                  = zeros(5,1);           % ��ʼΪ��״̬ 
    str                 = [];               	% ϵͳ����
    ts                  = [0 0];            	% ��ʼ������ʱ������
    
function sys=mdlDerivatives(t,x,u,Dm,Wm,l,K,Td,g)
                                                % ����״̬ת�Ʒ���
    Ma=[1   0   0   0   0  ;   0 Dm+Wm 0     -Wm*l*cos(x(3)) 0 ;0    0   1  0   0;
        0  cos(x(3)) 0 -l   0;   0   0   0   0  l];
    Mb=[0 1 0 0 0 ;0 0 0 -Wm*sin(x(3))*x(4) 1 ; 0 0 0 1 0 ;0 0 0 0 0 ;0 0 0 0 -1/Td];
    MB=[0;0;0;g*sin(x(3));0];
    MD=[0;0;0;0;K/Td];                          % �����״̬����
    sys=inv(Ma)*Mb*x+inv(Ma)*(MB)+inv(Ma)*MD*u;
                                                % �õ���ǰ״̬��ֵ
        
function sys=mdlUpdate(t,x,u)                   %����ɢ״̬      
    sys = [];

function sys=mdlOutputs(t,x,u,X_0)
                                                % ϵͳ���Ϊ����״̬
    if(x(1)>=X_0)                               % ��λ�õ���Ԥ����λ�õ�ʱ�����ø�������ֵ
        x(1)=X_0;                               % ������λ�ù̶���Ԥ��λ��
        x(2)=0;                                 % �������ٶ���Ϊ��
        x(3)=0.1*x(3);                          % �����ӽǶȵ�˥��ֵ����Ϊ0.1
        x(4)=0.1*x(4);                          % �����ӽ��ٶ�˥��ֵ����Ϊ0.1
        x(5)=0;                                 % ������������Ϊ0
    end
    sys = x;                                    % �����״̬����

function sys=mdlGetTimeOfNextVarHit(t,x,u)
    sampleTime = [];

function sys=mdlTerminate(t,x,u)
    sys = []; 
    
    