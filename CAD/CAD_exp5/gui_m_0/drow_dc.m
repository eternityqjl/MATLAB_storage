% 函数名称：drow_dc
% 传入参数：X_M  吊车此时的横坐标
% 函数功能：通过给定吊车的横坐标，做出边长为4的吊车示意图并象征性的画出吊车
%           的两个轮子
function drow_dc(X_M)                           % 给出横坐标的位置
    hold on;                                    % 保持窗格
    r=2;                                        % 半径为2
    plot([X_M-4 X_M+4 X_M+4 X_M-4 X_M-4],[60+2*r ...
        60+2*r 68+2*r 68+2*r 60+2*r],'k','linewidth',1.3 );
                                                % 做出吊车的外轮廓
    %%%%%%%画出左边轮子%%%%%%%%
    hold on;                                    % 保持窗格
    theta=0:2*pi/3600:2*pi;                     % 得到角度
    r_x=X_M-6+r;                                % 得到圆心的横坐标位置
    r_y=60+r;                                   % 得到圆心的纵坐标位置
    Circle1=r_x+r*cos(theta);                   % 得到圆形的x坐标
    Circle2=r_y+r*sin(theta);                   % 得到圆形的y坐标
    plot(Circle1,Circle2,'k','Linewidth',1.3);  % 做圆
    %%%%%%画出右边轮子%%%%%%%%
    hold on;                                    % 保持窗格
    theta=0:2*pi/3600:2*pi;                     % 得到角度
    r_x=X_M+6-r;                                % 得到圆心的横坐标位置               
    r_y=60+r;                                   % 得到圆心的纵坐标位置
    Circle1=r_x+r*cos(theta);                   % 得到圆形的x坐标
    Circle2=r_y+r*sin(theta);                   % 得到圆形的y坐标
    plot(Circle1,Circle2,'k','Linewidth',1.3);  % 做圆
end