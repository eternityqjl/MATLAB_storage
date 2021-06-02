% 函数名称：drow_gd
% 函数功能：画出一条横线作为轨道，并添加小斜线作为轨道阴影
function drow_gd                                % 画出轨道
    gd_x1=-5:5:105;                             % 得到轨道的第一条横坐标
    gd_x2=gd_x1-2;                              % 得到轨道的第二条横坐标
    n=length(gd_x1);                            % 得到长度
    gd_y1=60*ones(1,n);                         % 得到轨道的第一条纵坐标
    gd_y2=58*ones(1,n);                         % 得到轨道的第二条纵坐标
    for i=1:n                                   % 循环做线条 这里做出小斜线
        hold on                                 % 保持窗格
        plot([gd_x1(i),gd_x2(i)],[gd_y1(i),gd_y2(i)],'k','linewidth',2.0)
                                                % 做出小斜线
    end
    hold on                                     % 保持窗格
    plot([-5 105],[60 60],'k','linewidth',2.0)  % 做出轨道
    axis([-5 105 -5 78])                        % 对窗格横纵坐标进行设置
end