%% test8_3_1
clear;clc
ng0 = [1];                                      %ԭϵͳ�������ݺ�������
dg0 = conv([1,0.2],conv([1,1],[1,5]));          %ԭϵͳ�������ݺ�����ĸ
g0 = tf(ng0,dg0)                                %ԭϵͳ�������ݺ���
t = [0:0.01:100];                               %ʱ��Χ
y = step(g0,t);                                 %ϵͳ�ĵ�λ��Ծ��Ӧ����
dy = diff(y);                                   %���ò��������߸����б��
[k,x] = max(dy);                             
k = k * 100;                                    %�ҳ�б�����ֵ����λ��
t_max = x * 0.01;
y_max = y(x);                                   %б�����ֵ��ĺ�������
b = y_max - k * t_max                           %����ؾ�
K = max(y);                                     %��ֵ̬
tao = abs(b) / k;                               %�����ͺ�ʱ��tao
T = K / k;                                      %����ʱ�䳣��T
Kp = 0.9 * T / tao;
Ti = tao / 0.3;
PI = Kp * (1 + tf(1,[Ti,0]))                    %�õ�PI������
Kp = 1.2 * T / tao;
Ti = 2 * tao;
Td = 0.5 * tao;
PID = Kp * (1 + tf(1,[Ti,0]) + tf([Td,0],[1]))  %�õ�PID������

%% test8_3_2
%�����������ĵ�λ��Ծ��Ӧ
sysPI = feedback(PI * g0,1);
sysPID = feedback(PID * g0,1);
step(sysPI,t)
title('����PI��������ĵ�λ��Ծ��Ӧ')
figure();
step(sysPID,t)
title('����PID�������ĵ�λ��Ծ��Ӧ')

%��PI�������Ĳ������е���
Kp = 0.65 * 0.9 * T / tao;
Ti = 3 * tao / 0.3;
PI = Kp * (1 + tf(1,[Ti,0]))                    %�����ı���PI������
sysPI = feedback(PI * g0,1);
figure
step(sysPI,t)
title('����ı������PI�������ĵ�λ��Ծ��Ӧ')
ss1=stepinfo(sysPI);    %�ı��PI�������ĵ�λ��Ծ��Ӧ
fprintf('PI���������ڲ�����ĳ�������%f\n',ss1.Overshoot)

%��PID�������Ĳ������е���
Kp = 1.25 * T / tao;
Ti = 2.55 * 2 * tao;
Td = 0.5 * tao;
PID = Kp * (1 + tf(1,[Ti,0]) + tf([Td,0],[1]))   %�����ı���PI������
sysPID = feedback(PID * g0,1);
figure
step(sysPID,t)
title('����ı������PID�������ĵ�λ��Ծ��Ӧ')
ss2=stepinfo(sysPID);   %�ı��PID�������ĵ�λ��Ծ��Ӧ
fprintf('PID���������ڲ�����ĳ�������%f\n',ss2.Overshoot)
fprintf('\n')

%% test8_3_3
t = 0:0.01:50; 
%PI
g1 = sysPI * tf([1],[1,0,0]);                     %����б�º���       
y1 = impulse(g1,t);                               %��λб����Ӧ
errorPI = t - y1';                                %�������
figure;
plot(t,errorPI)                                   %����ͼ��
title('PI�����')
xlabel('t')
ylabel('errorPI')

n = length(t);
ess1 = errorPI(n);                                %�õ���ֵ̬
maxE1 = max(errorPI);                             %��÷�ֵ
overshoot1 = 100 * (maxE1 - ess1) / ess1;         %���㳬����
for i = n : -1 : 1
    if errorPI(i) < 0.98 * ess1 || errorPI(i) > 1.02 * ess1
    ts1 = t(i);                                   %�õ�����ʱ�䣬����Ϊ2%
    break
    end
end
disp('����PI��������')
fprintf('��̬��%f\n',ess1)
fprintf('��������%f\n',overshoot1)
fprintf('����ʱ�䣺%f\n',ts1)
fprintf('\n')

%PID
g2 = sysPID * tf([1],[1,0,0]);                    %����б�º���
y2 = impulse(g2,t);                               %��λб����Ӧ
errorPID = t - y2';                               %�������
figure;
plot(t,errorPID)                                  %����ͼ��
xlabel('t')
ylabel('errorPID')
title('PID�����')

ess2 = errorPID(n);                               %�õ���ֵ̬
maxE2 = max(errorPID);                            %��÷�ֵ
overshoot2 = 100 * (maxE2 - ess2) / ess2;         %���㳬����
for i = n : -1 : 1
    if errorPID(i) < 0.98 * ess2 || errorPID(i) > 1.02 * ess2
    ts2 = t(i);                                   %�õ�����ʱ�䣬����Ϊ2%
    break
    end
end
disp('����PID��������')
fprintf('��̬��%f\n',ess2)
fprintf('��������%f\n',overshoot2)
fprintf('����ʱ�䣺%f\n',ts2)