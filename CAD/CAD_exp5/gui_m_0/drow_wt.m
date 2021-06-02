% 函数名称：drow_wt
% 传入参数: X_M  吊车此时的横坐标
%           X_j  绳子与竖直方向的夹角 
% 函数功能：通过给定吊车的横坐标，做出边长为2的物体示意图，并使用黑色线条
%          将吊车与物体连接
function  drow_wt(X_M,X_j)                          % 传入吊车的横坐标
                                                    % 和绳子与竖直的夹角
    hold on                                         % 保持窗格
    l=20;                                           % 函数窗格中扩大一倍
    X_m=X_M-l*sin(X_j);                             % 得到物体的横坐标
    Y_m=60-l*cos(X_j);                              % 得到物体的纵坐标
    plot([X_M X_m],[60 Y_m],'k','linewidth',1.3 )   % 画出绳子
    hold on                                         % 保持窗格
    plot([X_m-2 X_m+2 X_m+2 X_m-2 X_m-2],[Y_m-2 Y_m-2 ...
        Y_m+2 Y_m+2 Y_m-2],'k','linewidth',1.3 );
                                                    % 画出物体的外轮廓
end