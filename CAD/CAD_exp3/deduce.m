[A,B,C,D]=linmod('launcher_dir')
sys=ss(A,B,C,D)
sys=tf(sys);
[num,den]=tfdata(sys);                     %获取传递函数模型属性值
num=cell2mat(num);                         %将cell类型转换为mat类型，以便于求根
den=cell2mat(den);                         %将cell类型转换为mat类型，以便于求根
p=roots(den)                               %求取系统极点
z=roots(num)                               %求取系统零点
wd=0;                                      %定义判断系统稳定性标志
psize=size(den);                           %求取系统特征式大小
psize=psize(:,2);                          %求取系统特征式最高阶数
for i=1:(psize-1)                          %判断系统极点位于虚轴左侧的个数
    if real(p(i))<0
        wd=wd+1;
    end
end
if wd==(psize-1)                           %若系统极点均位于虚轴左侧，则系统稳定
    disp("系统稳定")
else                                       %否则系统不稳定
    disp("系统不稳定")
end
Qc=ctrb(A,B);                              %求系统能控性判断矩阵Qc
if rank(Qc)==(length(den)-1)               %如果Qc满秩，则系统可控。
    disp("系统可控")                         
else
    disp("系统不可控")
end
Qo=obsv(A,C);                              %求系统可观测性判断矩阵Qo
if rank(Qo)==(length(den)-1)               %如果Qo满秩，则系统可观。
    disp("系统可观")
else
    disp("系统不可观")
end