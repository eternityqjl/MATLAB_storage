function varargout = launcher(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @launcher_OpeningFcn, ...
        'gui_OutputFcn',  @launcher_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
function launcher_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    a=imread('frameWork.jpg');                  % 读入图片
    axes(handles.axes1);                        %指定图窗
    imshow(a);                                  % 显示图片
    global flag_huitu                          
    flag_huitu=0;                               % 定义flag变量
    
function varargout = launcher_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;

%% 函数名称：simulation_Callback
%  函数功能：实现对于基本PID控制和模糊PID控制的各项参数的展示
function simulation_Callback(hObject, eventdata, handles)
   [A,B,C,D]=linmod('launcher_dir');        % 得到线性化参数
    sys=ss(A,B,C,D);                                    % 得到线性化模型
    assignin('base','A',A)                          % 传入工作空间
    assignin('base','B',B)
    assignin('base','C',C)
    assignin('base','D',D)
    simOut = sim('launcher_dir','AbsTol','1e-6');              % 得到仿真数据
    
    %% 
    %% 判断图窗以及新建图窗
    if flag_huitu==1                                % 若不是第一次作图
        axes('parent',handles.uipanel11);           % 重建一个axes
    else
        axes(handles.axes13)                        % 使用axes13作图
    end
    flag_huitu=1;                                   % 置为1
    cla;                                            % 新建图窗
    %% 获取菜单的值进行性能计算
    pop1Value = get(handles.popupmenu1,'value');    % 获取菜单1的选项
    pop2Value = get(handles.popupmenu2,'value');    % 获取菜单2的选项
    %% 状态显示
    if(pop1Value==2&&pop2Value==2)                  % 基本LQR控制状态显示
        line='r--';                                 % 选取红色虚线
        ztxs(t_jb,y_jb,line,0)                      % 不使用hold on 作图
    elseif(pop1Value==3&&pop2Value==2)              % 遗传LQR控制状态显示
        line='b-.';                                 % 选取蓝色点画线
        ztxs(t_yc,y_yc,line,0)                      % 不使用hold on 作图
    elseif(pop1Value==4&&pop2Value==2)              % 基本lqr与遗传LQR控制状态对比
        line='r--';
        ztxs(t_jb,y_jb,line,1)                      % 基本lqr作图并保持
        line='b-.';
        ztxs(t_yc,y_yc,line,1)                      % 遗传lqr作图并保持
        hl=legend('Ordinary','Inheritance');        % 加上图例
        set(hl,'Box','off');                        % 取消边框
        set(hl,'Orientation','horizon')             % 横向显示
        set(hl,'position',[0.3552 0.9537 0.3424 0.0442]);
                                                    % 设置图例的位置
        set(hl,'Units','Normalized'...
            ,'FontUnits','Normalized')              % 这是防止变化时，产生较大的形变。
   %% 线性与非线性对比
    elseif(pop1Value==2&&pop2Value==3)              % 基本LQR控制的线性与非线性比较
        line_noline(A,B,C,D,KK_jb)
    elseif(pop1Value==3&&pop2Value==3)              % 遗传LQR控制的线性与非线性比较
        line_noline(A,B,C,D,KK_yc)
   %% 鲁棒性分析
    elseif(pop1Value==2&&pop2Value==5)              % 基本LQR控制的鲁棒性分析
        lineStyle = {'b', 'r', 'c', 'y','m','k'};   % 定义线型
        lbxcs(KK_jb,lineStyle,0);
    elseif(pop1Value==3&&pop2Value==5)              % 遗传LQR控制的鲁棒性分析
        lineStyle = {'b--', 'r--', 'c--', 'y--','m--','k--'};
                                                    % 定义线型
        lbxcs(KK_yc,lineStyle,0);
    elseif(pop1Value==4&&pop2Value==5)              % 基本lqr与遗传lqr鲁棒性对比分析
        lineStyle = {'k', 'k', 'k', 'k','k','k'};   % 基本lqr线型
        lbxcs(KK_jb,lineStyle,1);                   % 作图并保持
        lineStyle = {'r--', 'r--', 'r--', 'r--','r--','r--'};
        lbxcs(KK_yc,lineStyle,1);
        hl=legend('Ordinary','Inheritance');        % 做出图例
        set(hl,'Box','off');                        % 取消边框
        set(hl,'Orientation','horizon')             % 横向显示
        set(hl,'position',[0.3552 0.9537 0.3424 0.0442]);          
                                                    % 设置图例的位置
        set(hl,'Units','Normalized','FontUnits','Normalized')       
                                                    % 这是防止变化时，产生较大的形变。
    %% 噪声响应分析
    elseif(pop1Value==2&&pop2Value==4)              % 基础LQR的噪声响应分析
        zsxyfx(A,B,C,D,KK_jb);
    elseif(pop1Value==3&&pop2Value==4)              % 遗传LQR的噪声响应分析
        zsxyfx(A,B,C,D,KK_yc);
    elseif(pop1Value==4&&pop2Value==4)              % 基础LQR与遗传LQR的噪声对比分析
        y_zxjb=zsxyfx(A,B,C,D,KK_jb);               % 得到基础噪声响应
        y_zxyc=zsxyfx(A,B,C,D,KK_yc);               % 得到遗传噪声响应
        t_input=linspace(0,max(t_jb),length(t_jb)); % 得到阶跃响应时间
        zsxy(t_input,y_zxjb,t_input,y_zxyc);        % 作图
        hl=legend('Ordinary','Inheritance');        % 加上图例
        set(hl,'Box','off');                        % 不要边框
        set(hl,'Orientation','horizon')             % 横向显示
        set(hl,'position',[0.3552 0.9537 0.3424 0.0442]);           
                                                    % 设置图例的位置
        set(hl,'Units','Normalized','FontUnits','Normalized')       
                                                    % 这是防止变化时，产生较大的形变。
    end
    
    
%% 函数名称：zsxyfx 噪声响应分析
%  函数功能：传入线性化模型参数，并得到下拉菜单的噪声类型和强度进行输入分析
%  传入参数： A,B,C,D：原系统参数 KK:使用状态反馈矩阵  
%  传出参数： y_zssy：输出的噪声响应序列值   
function y_zssy=zsxyfx(A,B,C,D,KK)
        handles = guihandles();                     % 得到句柄
        pop3Value = get(handles.popupmenu3,'value');% 获取算法弹出框中的选项
        pop4Value = get(handles.popupmenu4,'value');% 获取算法弹出框中的选项
        global y_jb;                                % 定义全局变量
        global t_jb;
        AA=A-B*KK;                                  % 得到反馈矩阵的系统
        sys=ss(AA,B,C,D);                           % 得到系统
        n=length(y_jb);                             % 得到时间数据长度
        y_step=10*ones(n,1);                        % 得到基础输入
        t_input=linspace(0,max(t_jb),n);            % 得到阶跃响应时间
        y_yuanshi = lsim(sys,y_step,t_input);       % 获得加上噪声的输入响应数据
        switch pop3Value                            % 对菜单三进行判断
            case 2                                  % 选项为2时噪声强度为0
                zsqd = 0;
            case 3                                  % 选项为2时噪声强度为0.1
                zsqd = 0.1;
            case 4                                  % 选项为2时噪声强度为0.5
                zsqd = 0.5;
            case 5                                  % 选项为2时噪声强度为1
                zsqd = 1;
            case 6                                  % 选项为2时噪声强度为5
                zsqd = 5;               
            otherwise                               % 默认噪声强度为0
                zsqd = 0;
        end
        n_gaussian=0;                               % 初始化噪声输入值
        switch pop4Value                            % 对菜单四进行判断
            case 2                                  % 高斯噪声
                n_gaussian = zsqd .* randn(n,1);
            case 3                                  % 高斯白噪声
                n_gaussian=wgn(n,1,zsqd);
            case 4
                n_gaussian=-0.2*zsqd*t_input;       % 得到线性输入
                n_gaussian=(n_gaussian-0.5*min(n_gaussian))';
                                                    % 将线型输入转化为对称线性
            case 5
                n_gaussian=(zsqd*sin(1000*t_input))';% 得到正弦输入
            case 6
                n_gaussian=0;                       % 选择无噪声
            otherwise
                n_gaussian=0;                       % 默认无噪声
        end
        y_input=y_step+n_gaussian;                  % 得到加入噪声的输入信号
        y_zssy = lsim(sys,y_input,t_input);         % 获得闭环系统的幅值为10的阶跃响应数据
        zsxy(t_input,y_yuanshi,t_input,y_zssy);     % 作图
        

 %% 函数名称：zsxy 噪声响应作图函数
%  函数功能：传入需要作图的两个序列的时间以及信号，作图
%  传入参数： t,t1 输入时间 y,y1输入信号 
 function zsxy(t,y,t1,y1)
    subplot(321)                                    % 做子图
    plot(t, y(:,1),'k-', t1, y1(:,1),'r-.')         % 做出位移的图像
    title('Displacement')                           % 加入标题
    grid on                                         % 加入网格线
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    subplot(322)                                    % 做子图
    plot(t, y(:,2),'k-',t1, y1(:,2),'r-.')          % 做出图像
    title('speed')                                  % 添加速度标题
    grid on                                         % 加入网格线
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    subplot(323)                                    % 做子图
    plot(t, y(:,3),'k-', t1, y1(:,3),'r-.')         % 做绳子角度图像
    title('rope angle')                             % 添加标题
    grid on                                         % 加入网格线
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    subplot(324)                                    % 做子图
    plot(t, y(:,4),'k-', t1, y1(:,4),'r-.')         % 做图像
    title('rope angle speed')                       % 添加标题
    grid on                                         % 加入网格线
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    subplot(313)                                    % 做子图
    plot(t, y(:,5),'k-', t1, y1(:,5),'r-.')         % 做图像
    title('driving force')                          % 添加标题
    grid on                                         % 加入网格线
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    hl=legend('Original response','Noise response');% 添加图例
    set(hl,'Box','off');                            % 设置无边框
    set(hl,'Orientation','horizon')                 % 设置横向显示
    set(hl,'position',[0.3252 0.9556 0.4529 0.0445]);% 设置图例的位置
    set(hl,'Units','Normalized','FontUnits','Normalized')
                                                    % 这是防止变化时，产生较大的形变。
%% 函数名称：ztxs 状态显示
%  函数功能：显示当前KK值对应的simulink仿真，并将结果显示出来
%  传入参数：t,y simulink的仿真结果
%            line:线型 hold_flag:是否保持窗格
function ztxs(t,y,line,hold_flag)
        subplot(321);                               % 做子图
        if(hold_flag==1)                            % 若hold标志为1
            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗格
        end
        plot(t, y(:,1),line)                        % 做出位移的图像
        title('Displacement')                       % 加入标题
        grid on                                     % 加入网格线
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗格
        subplot(322);                               % 做子图
        if(hold_flag==1)                            % 若hold标志为1
            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗格
        end
        plot(t, y(:,2),line)                        % 做出图像
        title('speed')                              % 添加速度标题
        grid on                                     % 加入网格线
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗格
        subplot(323);                               % 做子图
        if(hold_flag==1)                            % 若hold标志为1
            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗格
        end
        plot(t, y(:,3),line)                        % 做绳子角度图像
        title('rope angle')                         % 添加标题
        grid on                                     % 加入网格线
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗格
        subplot(324);                               % 做子图
        if(hold_flag==1)                            % 若hold标志为1
            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗格
        end 
        plot(t, y(:,4),line)                        % 做图像
        title('rope angle speed')                   % 添加标题
        grid on                                     % 加入网格线
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗格
        subplot(313);                               % 做子图
        if(hold_flag==1)                            % 若hold标志为1
            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗格
        end
        plot(t, y(:,5),line)                        % 做图像
        title('driving force')                      % 添加标题
        grid on                                     % 加入网格线
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗格
%% fuzzyPID_Callback
%  模糊PID
function fuzzyPID_Callback(hObject, eventdata, handles)
    global time;
    time=0;                                             % 瀹氫箟璁＄畻娆℃暟锛屽垵鍊间贄1�7    KK_yc=[3.2966 18.1250 -18.9404 -117.5919 0.0001];   % 寰楀埌鍒濆���ￄ1�7
    [A,B,C,D]=linmod('launcher_dir_disturbance')
    sys=ss(A,B,C,D)
    axes(handles.axes3);                        % 指定视窗3
    step(sys);
    data = sim('Copy_of_launcher_dir_disturbance');
    P = data.yout.signals.values(:,1);
    I = data.yout.signals.values(:,2);
    D = data.yout.signals.values(:,3);
    assignin('base','P',P)
    assignin('base','I',I)
    assignin('base','D',D)
%% 函数名称：normalPID_Callback
%  函数功能：实现对于基本PID控制的结果展示
function normalPID_Callback(hObject, eventdata, handles)
    %% 定义全局变量
    global  Kp;
    global  Ki;
    global  Kd;
    global  Kpp;
    global  Kip;
    global  Kdp;
    axes(handles.axes2) % 选中画图使用的视窗
    %系统参数
    r = 476.3;
    R = 537.7;
    x0 = 836;
    
    sim('exp4');
    
    R = 500;                   %半径
    h = 0.5;                   %圆柱高度
    m = 100;                   %分割线的条数
    [x,y,z] = cylinder(R,m);   %创建以(0,0)为圆心，高度为[0,1]，半径为R的圆柱
    z = h*z;                   %高度放大h倍

    surf(x,y,z-255)
    axis([-1.5*R 1.5*R -1.5*R 1.5*R 0 h*50])
    hold on

    plot3([0,0],[0,0],[0,-255])  % 

    thet=ans.simout.data(:,1);   % 常规PID控制数据
    alp = ans.simout.data(:,4);  % 模糊PID控制数据
    Pc1 =[0,0,0];
    Pc2 = [600,300,0];
    x = [Pc1(1);Pc2(1)];
    y = [Pc1(2);Pc2(2)];
    z = [Pc1(3);Pc2(3)];
    plot3(x,y,z)
    hold on
    h = plot3(x,y,z);
    axis tight equal

    %录制电影动画
    n = min(length(thet),length(alp));
    n
    M = moviein(n);
    for j=1:1000:n
        axis([-600 600 -600 600 -400  400]);
        rotate(h,[1 0 0],alp(j,:),[0,0,0])  % 运动学解算 pitch 轴
        rotate(h,[0 0 1],thet(j,:),[0,0,0]) % 运动学解算 yaw 轴
        M(:, j) = getframe;
    end
    axis tight equal
%% 函数名称：pushbutton1_Callback
%  函数功能：实现对于桥式吊车系统的基本参数的设定以及判断系统的能控能观和稳定性����
function pushbutton1_Callback(hObject, eventdata, handles)
    %% 得到各项输入并传递入基本空间中
    Dm=str2double(get(handles.Dm,'string'))         % 得到输入的各项参数
    Cm=str2double(get(handles.Cm,'string'))         % 总泄漏系数
    Jt=str2double(get(handles.Jt,'string'))         % 总惯量
    Vm=str2double(get(handles.Vm,'string'))         % 总容积
    Ka=str2double(get(handles.Ka,'string'))         % 电流位移控制比例
    betae=str2double(get(handles.betae,'string'))   % 弹性模量
    M1=str2double(get(handles.M1,'string'))         % 负载力矩
    Kq=str2double(get(handles.Kq,'string'))         % 弹性模量
    Kc=str2double(get(handles.Kc,'string'))         % 负载力矩
   omegah=str2double(get(handles.omegah,'string'))         % 弹性模量
    xih=str2double(get(handles.xih,'string'))
    Kce = Kc + Cm;
%     omegah = sqrt(4*betae*Dm^2/(Vm*Jt));
%     xih = Kce/Dm * sqrt(betae*Jt/Vm);                
    
    num = [Ka*Kq/Dm];                               % 系统传递函数
    den = [1/omegah^2, 2*xih/omegah, 1, 0];
    sys = tf(num,den);
    
    [A, B, C, D] = ss(sys).data                  % 传递函数转状态空间
    
    %% 传入工作空间
    assignin('base','Dm',Dm)                        
    assignin('base','Cm',Cm)
    assignin('base','Jt',Jt) 
    assignin('base','Vm',Vm)
    assignin('base','Ka',Ka)
    assignin('base','betae',betae)
    assignin('base','M1',M1)
    assignin('base','Kq',Kq)
    assignin('base','Kc',Kc)
    assignin('base','omegah',omegah)
    assignin('base','xih',xih)
    sys=ss(A,B,C,D);                                % 传入工作空间
    p=eig(A);                                       % 提取极点值
    Tc=ctrb(A,B);                                   % 可控性矩阵
    Qc=rank(Tc);                                    % 求秩
    To=obsv(A,C);                                   % 可观性矩阵
    Qo=rank(To);                                    % 求秩
    n=length(A);                                    % 求状态矩阵的秩
    if sum(real(eig(sys.A))<0)==length(sys.A)       % 判断系统稳定性
        stable_or_not=['系统稳定'];                           % 系统稳定
    else                                            % 若状态矩阵的特征值大于0
        stable_or_not=['系统不稳定'];                         % 系统不稳定
    end
    if(n==Qc)                                       % 可控矩阵满秩
        Tc_flag=['完全能控'];                        % 系统完全能控
    else
        Tc_flag=['不完全能控'];                        % 系统不完全能控
    end
    if(n==Qo)                                       % 可观矩阵满秩
        Qc_flag='完全能观';                          % 系统完全能观
    else
        Qc_flag='不完全能观';                        % 系统不完全能观
    end
    %% 回显
    set(handles.stable, 'String', stable_or_not);               % 显示系统的稳定性
    set(handles.Qc, 'String', Tc_flag);             % 显示系统的能控性
    set(handles.Qo, 'String', Qc_flag);             % 显示系统的能观性
    set(handles.p1, 'String', num2str(p(1)));
    set(handles.p2, 'String', num2str(p(2)));
    set(handles.p3, 'String', num2str(p(3)));
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function jygs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function zqdx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function bygl_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function wyds_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Kp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function K6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function K5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function K4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function K3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function K2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function K1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stable_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Qo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Qc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Dm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Wm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function K_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Td_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function l_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function X_0_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Q11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Q33_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Q22_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Q66_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Q44_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Q55_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit39_Callback(hObject, eventdata, handles)
function ycds_Callback(hObject, eventdata, handles)
function edit39_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ycds_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu1_Callback(hObject, eventdata, handles)
function axes1_CreateFcn(hObject, eventdata, handles)
    
function axes2_CreateFcn(hObject, eventdata, handles)
function axes3_CreateFcn(hObject, eventdata, handles)
function axes4_CreateFcn(hObject, eventdata, handles)
function K1_Callback(hObject, eventdata, handles)
function K2_Callback(hObject, eventdata, handles)
function K3_Callback(hObject, eventdata, handles)
function K4_Callback(hObject, eventdata, handles)
function K5_Callback(hObject, eventdata, handles)
function p1_Callback(hObject, eventdata, handles)
function p2_Callback(hObject, eventdata, handles)
function p3_Callback(hObject, eventdata, handles)
function p4_Callback(hObject, eventdata, handles)
function p5_Callback(hObject, eventdata, handles)
function Qo_Callback(hObject, eventdata, handles)
function Qc_Callback(hObject, eventdata, handles)
function Dm_Callback(hObject, eventdata, handles)
function Wm_Callback(hObject, eventdata, handles)
function K_Callback(hObject, eventdata, handles)
function Td_Callback(hObject, eventdata, handles)
function l_Callback(hObject, eventdata, handles)
function X_0_Callback(hObject, eventdata, handles)
function stable_Callback(hObject, eventdata, handles)
function Q11_Callback(hObject, eventdata, handles)
function Q22_Callback(hObject, eventdata, handles)
function Q33_Callback(hObject, eventdata, handles)
function Q44_Callback(hObject, eventdata, handles)
function Q55_Callback(hObject, eventdata, handles)
function k_lqr5_Callback(hObject, eventdata, handles)
function k_lqr4_Callback(hObject, eventdata, handles)
function k_lqr3_Callback(hObject, eventdata, handles)
function k_lqr2_Callback(hObject, eventdata, handles)
function k_lqr1_Callback(hObject, eventdata, handles)
function k_lqr5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k_lqr4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k_lqr3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k_lqr2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function k_lqr1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu2_Callback(hObject, eventdata, handles)
function popupmenu3_Callback(hObject, eventdata, handles)
function popupmenu5_Callback(hObject, eventdata, handles)

function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function jygs_Callback(hObject, eventdata, handles)
function zqdx_Callback(hObject, eventdata, handles)
function bygl_Callback(hObject, eventdata, handles)
function wyds_Callback(hObject, eventdata, handles)
function popupmenu10_Callback(hObject, eventdata, handles)
function popupmenu10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu11_Callback(hObject, eventdata, handles)
function popupmenu11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu4_Callback(hObject, eventdata, handles)
function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function axes13_CreateFcn(hObject, eventdata, handles)


% --- Executes on mouse press over axes background.
function axes13_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function axes13_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on simulation and none of its controls.
function simulation_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to simulation (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function Cm_Callback(hObject, eventdata, handles)
% hObject    handle to Cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cm as text
%        str2double(get(hObject,'String')) returns contents of Cm as a double


% --- Executes during object creation, after setting all properties.
function Cm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Jt_Callback(hObject, eventdata, handles)
% hObject    handle to Jt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Jt as text
%        str2double(get(hObject,'String')) returns contents of Jt as a double


% --- Executes during object creation, after setting all properties.
function Jt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Jt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Vm_Callback(hObject, eventdata, handles)
% hObject    handle to Vm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Vm as text
%        str2double(get(hObject,'String')) returns contents of Vm as a double


% --- Executes during object creation, after setting all properties.
function Vm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function G_Callback(hObject, eventdata, handles)
% hObject    handle to G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G as text
%        str2double(get(hObject,'String')) returns contents of G as a double


% --- Executes during object creation, after setting all properties.
function G_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bm_Callback(hObject, eventdata, handles)
% hObject    handle to Bm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bm as text
%        str2double(get(hObject,'String')) returns contents of Bm as a double


% --- Executes during object creation, after setting all properties.
function Bm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pl_Callback(hObject, eventdata, handles)
% hObject    handle to Pl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pl as text
%        str2double(get(hObject,'String')) returns contents of Pl as a double


% --- Executes during object creation, after setting all properties.
function Pl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betae_Callback(hObject, eventdata, handles)
% hObject    handle to betae (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betae as text
%        str2double(get(hObject,'String')) returns contents of betae as a double


% --- Executes during object creation, after setting all properties.
function betae_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betae (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function M1_Callback(hObject, eventdata, handles)
% hObject    handle to M1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of M1 as text
%        str2double(get(hObject,'String')) returns contents of M1 as a double


% --- Executes during object creation, after setting all properties.
function M1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fuzzy.
function fuzzy_Callback(hObject, eventdata, handles)
    fis = readfis('./Fuzzy.fis') % 读取模糊集文件
    assignin('base','fis',fis)
    
% hObject    handle to fuzzy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fuzzy



function Kpf_Callback(hObject, eventdata, handles)
% hObject    handle to Kpf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kpf as text
%        str2double(get(hObject,'String')) returns contents of Kpf as a double


% --- Executes during object creation, after setting all properties.
function Kpf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kpf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kif_Callback(hObject, eventdata, handles)
% hObject    handle to Kif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kif as text
%        str2double(get(hObject,'String')) returns contents of Kif as a double


% --- Executes during object creation, after setting all properties.
function Kif_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kdf_Callback(hObject, eventdata, handles)
% hObject    handle to Kdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kdf as text
%        str2double(get(hObject,'String')) returns contents of Kdf as a double


% --- Executes during object creation, after setting all properties.
function Kdf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kp_Callback(hObject, eventdata, handles)
% hObject    handle to Kp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kp as text
%        str2double(get(hObject,'String')) returns contents of Kp as a double



function Ki_Callback(hObject, eventdata, handles)
% hObject    handle to Ki (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ki as text
%        str2double(get(hObject,'String')) returns contents of Ki as a double


% --- Executes during object creation, after setting all properties.
function Ki_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ki (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kd_Callback(hObject, eventdata, handles)
% hObject    handle to Kd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kd as text
%        str2double(get(hObject,'String')) returns contents of Kd as a double


% --- Executes during object creation, after setting all properties.
function Kd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    global Kp
    global Ki
    global Kd
    global Kpp
    global Kip
    global Kdp
    set(handles.Kp, 'String', 5.0);             % 推荐参数比例环节的系数
    set(handles.Ki, 'String', 0.2);             % 推荐参数积分环节的系数
    set(handles.Kd, 'String', 0.1);             % 推荐参数微分环节的系数
    Kp = 5.0
    Ki = 0.2
    Kd = 0.1
    Kpp = 5.0
    Kip = 0.2
    Kdp = 0.1
    assignin('base','Kp',Kp)
    assignin('base','Ki',Ki)
    assignin('base','Kd',Kd)
    assignin('base','Kpp',Kpp)
    assignin('base','Kip',Kip)
    assignin('base','Kdp',Kdp)
    



function Kq_Callback(hObject, eventdata, handles)
% hObject    handle to Kq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kq as text
%        str2double(get(hObject,'String')) returns contents of Kq as a double


% --- Executes during object creation, after setting all properties.
function Kq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kc_Callback(hObject, eventdata, handles)
% hObject    handle to Kc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kc as text
%        str2double(get(hObject,'String')) returns contents of Kc as a double


% --- Executes during object creation, after setting all properties.
function Kc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xv_Callback(hObject, eventdata, handles)
% hObject    handle to xv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xv as text
%        str2double(get(hObject,'String')) returns contents of xv as a double


% --- Executes during object creation, after setting all properties.
function xv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ka_Callback(hObject, eventdata, handles)
% hObject    handle to Ka (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ka as text
%        str2double(get(hObject,'String')) returns contents of Ka as a double


% --- Executes during object creation, after setting all properties.
function Ka_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ka (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit67_Callback(hObject, eventdata, handles)
% hObject    handle to p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p3 as text
%        str2double(get(hObject,'String')) returns contents of p3 as a double


% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pushbutton6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
    rules1=imread('rules1.jpg');                  % 导入规则库图像
    rules2=imread('rules2.jpg');                  % 导入规则库图像
    rules3=imread('rules3.jpg');                  % 导入规则库图像
    rules4=imread('rules4.jpg');                  % 导入规则库图像
    axes(handles.axes3);                        % 指定视窗3
    subplot(411)
    imshow(rules1);                              % 展示规则库
    subplot(412)
    imshow(rules2);                              % 展示规则库
    subplot(413)
    imshow(rules3);                              % 展示规则库
    subplot(414)
    imshow(rules4);                              % 展示规则库
    hold on;
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function simulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function omegah_Callback(hObject, eventdata, handles)
% hObject    handle to omegah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of omegah as text
%        str2double(get(hObject,'String')) returns contents of omegah as a double


% --- Executes during object creation, after setting all properties.
function omegah_CreateFcn(hObject, eventdata, handles)
% hObject    handle to omegah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xih_Callback(hObject, eventdata, handles)
% hObject    handle to xih (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xih as text
%        str2double(get(hObject,'String')) returns contents of xih as a double


% --- Executes during object creation, after setting all properties.
function xih_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xih (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
