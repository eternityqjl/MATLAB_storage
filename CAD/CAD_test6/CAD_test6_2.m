clear; clc
%% ״̬�ռ�ģ�͵ĸ�������A,B,C,D
A=[0 1 0 0;
   0 0 1 0;
   0 0 0 1;
   -2 -5 -1 -13];
B=[0;0;0;1];
C=[1 0 0 0];
D=0;
sys=ss(A,B,C,D); %ϵͳ��״̬�ռ�ģ��
%% ��λ��Ծ��Ӧ
subplot(3,1,1)
step(A,B,C,D)
%% ��λ������Ӧ
subplot(3,1,2)
impulse(A,B,C,D)
%% ��������Ӧ
x0=[2,3,4,5];
subplot(3,1,3)
initial(sys,x0)
%% ϵͳ�ȶ���
p=eig(A);   %��A���������ֵ
if(sum(real(p)>=0)==0)
    disp('ϵͳ�ȶ�')
else
    disp('ϵͳ���ȶ�')
end
%% ϵͳ�ɿ���
[n,~]=size(A);           % ���ϵͳ�Ľ״�
Tc=ctrb(A,B);            % ��ɿ��Ծ���
if rank(Tc)==n
    disp('ϵͳ�ܿ�')
else
    disp('ϵͳ���ܿ�')
end
%% ϵͳ�ɹ���
To=obsv(A,C);          % ��ɹ��Ծ���
if(rank(To)==n)
    disp('ϵͳ�ܹ�')
else
    disp('ϵͳ���ܹ�')
end