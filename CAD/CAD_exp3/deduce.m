[A,B,C,D]=linmod('launcher_dir')
sys=ss(A,B,C,D)
sys=tf(sys);
[num,den]=tfdata(sys);                     %��ȡ���ݺ���ģ������ֵ
num=cell2mat(num);                         %��cell����ת��Ϊmat���ͣ��Ա������
den=cell2mat(den);                         %��cell����ת��Ϊmat���ͣ��Ա������
p=roots(den)                               %��ȡϵͳ����
z=roots(num)                               %��ȡϵͳ���
wd=0;                                      %�����ж�ϵͳ�ȶ��Ա�־
psize=size(den);                           %��ȡϵͳ����ʽ��С
psize=psize(:,2);                          %��ȡϵͳ����ʽ��߽���
for i=1:(psize-1)                          %�ж�ϵͳ����λ���������ĸ���
    if real(p(i))<0
        wd=wd+1;
    end
end
if wd==(psize-1)                           %��ϵͳ�����λ��������࣬��ϵͳ�ȶ�
    disp("ϵͳ�ȶ�")
else                                       %����ϵͳ���ȶ�
    disp("ϵͳ���ȶ�")
end
Qc=ctrb(A,B);                              %��ϵͳ�ܿ����жϾ���Qc
if rank(Qc)==(length(den)-1)               %���Qc���ȣ���ϵͳ�ɿء�
    disp("ϵͳ�ɿ�")                         
else
    disp("ϵͳ���ɿ�")
end
Qo=obsv(A,C);                              %��ϵͳ�ɹ۲����жϾ���Qo
if rank(Qo)==(length(den)-1)               %���Qo���ȣ���ϵͳ�ɹۡ�
    disp("ϵͳ�ɹ�")
else
    disp("ϵͳ���ɹ�")
end