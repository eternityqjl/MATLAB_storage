clear; clc

%% ��simulinkģ�����Ի����õ�״̬�ռ�ģ��
[A,B,C,D]=linmod('CAD_test6_3_sim')
%% ����ϵͳ��״̬�ռ�ģ��
sys=ss(A,B,C,D)  
%% תΪ���ݺ���ģ��
gtf=tf(sys)  
%% ͨ��zpkģ������㼫��
gzpk=zpk(sys);
get(gzpk);                                    %��ȡģ����ϸ��Ϣ  
[z,p]=zpkdata(gzpk,'v')                 %�ڹ�������ʾģ����Ҫ����
%% ϵͳ�ȶ���
p=eig(A);   %��A���������ֵ
if(sum(real(p)>=0)==0)
    disp('ϵͳ�ȶ�')
else
    disp('ϵͳ���ȶ�')
end
%% ��λ��Ծ��Ӧ
step(A,B,C,D)