function varargout = tgb(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @tgb_OpeningFcn, ...
        'gui_OutputFcn',  @tgb_OutputFcn, ...
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
    
function tgb_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    a=imread('frameWork.jpg');                  % 得到a图
    axes(handles.axes1);                        % 取坐标轴1
    imshow(a);                                  % 显示a图
    global flag_huitu                           % 是否做子图标志
    flag_huitu=0;                               % 初值为0
    
function varargout = tgb_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;

%% 函数名称：pushbutton4_Callback
%  函数功能：实现对于基本lqr控制和遗传lqr控制的各项参数的展示
function pushbutton4_Callback(hObject, eventdata, handles)
    handles = guihandles();                         % 获得句柄
    global t_jb;                                    % 定义全局变量
    global y_jb;
    global KK_jb;
    global t_yc;
    global y_yc
    global KK_yc;
    global flag_huitu
    %% 得到基本lqr控制的仿真数据
    KK=KK_jb;                                       % 得到基本lqrKK值
    assignin('base','KK',KK)                        % 传入基本工作空间
    simOut = sim('step_Bridg','AbsTol','1e-6');     % 得到仿真数据
    t_jb = simOut.find('tout');                     % 得到时间变量
    y_jb = simOut.find('x_out');                    % 得到输出变量
    y_jb=y_jb.signals.values;                       % 得到输出信号
    assignin('base','y_jb',y_jb)                    % 传入基本工作空间
    assignin('base','t_jb',t_jb)
    %% 得到遗传lqr控制的仿真数据
    KK=KK_yc;                                       % 得到遗传lqrKK值
    assignin('base','KK',KK)                        % 传入基本工作空间
    simOut = sim('step_Bridg','AbsTol','1e-6');     % 得到仿真数据
    t_yc = simOut.find('tout');                     % 得到时间变量
    y_yc = simOut.find('x_out');                    % 得到输出变量
    y_yc=y_yc.signals.values;                       % 得到输出信号
    assignin('base','y_yc',y_yc)                    % 传入基本工作空间
    assignin('base','t_yc',t_yc)
    %% 得到函数线性化模型参数
    [A,B,C,D]=linmod('Bridge_crane_system');        % 得到线性化参数
    sys=ss(A,B,C,D);                                % 得到线性化模型
    assignin('base','A',A)                          % 传入工作空间
    assignin('base','B',B)
    assignin('base','C',C)
    assignin('base','D',D)
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
%% 函数名称：line_noline
%  函数功能：此函数是传入原系统的参数以及状态反馈矩阵的参数，求得线性化以及非线性化
%           的系统的幅值为10的阶跃函数响应曲线
%  传入参数： A,B,C,D：原系统参数 KK:求得的状态反馈矩阵
function line_noline(A,B,C,D,KK)
    KK=KK;
    assignin('base','KK',KK);
    %% 首先给定Q、R，求状态反馈矩阵K 
    [t,y]=sim('step_Bridg',30);                     % 得到的仿真数据
    n=length(t);                                    % 得到时间的长度
    maxT = t(n);                                    % 使用状态反馈K控制原二阶倒立摆，获得单位阶跃响应数据
    %% 构建线性化模型的闭环系统
    AA = A-B*KK;                                    % 得到加入反馈矩阵的系统矩阵
    sys1 = ss(AA, B, C, D);                         % 得到新的系统
    t_step=linspace(0,maxT,n);                      % 得到阶跃响应时间
    y_step = 10*ones(1,n);                          % 得到阶跃响应数值
    y1 = lsim(sys1,y_step,t_step);                  % 获得闭环系统的幅值为10的阶跃响应数据
    %% 对比K对线性化系统和原系统的控制效果
    subplot(321)                                    % 做子图
    plot(t, y(:,1), t_step, y1(:,1))                % 做出位移的图像
    title('Displacement')                           % 加入标题                      
    grid on                                         % 加入网格线
                                                    % 添加图例
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    subplot(322)                                    % 做子图
    plot(t, y(:,2), t_step, y1(:,2))                % 做出图像
    title('speed')                                  % 添加速度标题
    grid on                                         % 加入网格线
                                                    % 添加图例
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    subplot(323)                                    % 做子图
    plot(t, y(:,3), t_step, y1(:,3))                % 做绳子角度图像
    title('rope angle')                             % 添加标题
    grid on                                         % 加入网格线
                                                    % 添加图例
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    subplot(324)                                    % 做子图
    plot(t, y(:,4), t_step, y1(:,4))                % 做图像
    title('rope angle speed')                       % 添加标题
    grid on                                         % 加入网格线
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    subplot(313)                                    % 做子图
    plot(t, y(:,5), t_step, y1(:,5))                % 做图像
    title('driving force')                          % 添加标题
    grid on                                         % 加入网格线
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % 设置图像窗格
    hl=legend('Nonlinear','Linear');                % 添加图例
    set(hl,'Box','off');                            % 设置无边框
    set(hl,'Orientation','horizon')                 % 设置横向显示
    set(hl,'position',[0.3331 0.9516 0.3424 0.0442]);% 设置图例的位置
    set(hl,'Units','Normalized','FontUnits','Normalized')   
                                                    % 这是防止变化时，产生较大的形变。
%% 函数名称：lbxcs 鲁棒性分析
%  函数功能：此函数是通过改变系统的质量比，固定吊车的质量不变，改变物体的质量，
%           从而改变质量比以测试系统的鲁棒性。
function lbxcs(KK,lineStyle,hold_flag)
    KK=KK;              
    assignin('base','KK',KK);
    %% 测试当前K对模型参数变化的鲁棒性
    wrs = [0.1 1 4 10 40 100];                      % 物体与吊车质量比
    W0 = 1000;                                      % 物体质量与吊车质量相同
    for i=1:6
        Wm = W0 *wrs(i);                            % 现物体质量
        assignin('base','Wm',Wm);
        [t1,y1]=sim('step_Bridg',30);               % 得到仿真数据
        subplot(3,2,i)                              % 做子图
        if(hold_flag==1)                            % 若hold标志为1
            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗格
        end
        plot(t1, y1(:,1), lineStyle{i})             % 作图
        grid on                                     % 加上网格线
        title(sprintf('Displacement mass ratio=%4.2f',wrs(i)))
                                                    % 加上标题
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 对图像窗格进行设置
    end
%% 函数名称：pushbutton3_Callback
%  函数功能：实现对于遗传lqr控制的KK值的求解
function pushbutton3_Callback(hObject, eventdata, handles)
    global KK_yc;                                       % 定义全局变量
    global wyds;
    global time;
    time=0;                                             % 定义计算次数，初值为0
    KK_yc=[3.2966 18.1250 -18.9404 -117.5919 0.0001];   % 得到初值
    pop11Value = get(handles.popupmenu11,'value');      % 获取算法弹出框中的选项
    %% 判断下拉菜单的选择，并得到KK值
    switch pop11Value                                   % 对下拉菜单进行判断
        case 1                                          % 默认使用最优值
            KK=[3.2966 18.1250 -18.9404 -117.5919 0.0001];
        case 2                                          % 直接使用最优KK值
            KK=[3.4966 16.1250 -18.9404 -117.5919 0.0001];
        case 3                                          % 使用ga函数计算KK值
            %% 使用遗传算法进行求解KK值
            [A,B,C,D] = linmod('Bridge_crane_system');  % 使用linmod线性化的结果
            ycds= str2num(get(handles.ycds,'String'));  % 遗传代数
            jygs= str2num(get(handles.jygs,'String'));  % 精英个数
            zqdx= str2num(get(handles.zqdx,'String'));  % 种群大小
            bygl= str2num(get(handles.bygl,'String'));  % 变异概率
            wyds= str2num(get(handles.wyds,'String'));  % 位移点数
            assignin('base','ycds',ycds)                % 将变量传递到simulink中
            assignin('base','jygs',jygs)                
            assignin('base','zqdx',zqdx)
            assignin('base','bygl',bygl)
            assignin('base','wyds',wyds)
            fitnessfcn = @GA_LQR;                       % 适应度函数句柄
            nvars=4;                                    % 个体的变量数目
            LB = 0.1*ones(1,4);                         % 下限
            UB = 20*ones(1,4);                          % 上限
            options=gaoptimset('PopulationSize',zqdx,'PopInitRange',...
                [LB;UB],'EliteCount',jygs,'CrossoverFraction',bygl,...
                'Generations',ycds,'StallGenLimit',5,'TolFun',...
                1e-100,'PlotFcns',{@gaplotbestf,@gaplotbestindiv});
                                                        %参数设置
            [x_best,fval]=ga(fitnessfcn,nvars, [],[],[],[],LB,UB,[],options);
                                                        % 调用ga函数计算
            assignin('base','x_best',x_best)
            Q=diag([x_best(1) x_best(2) x_best(3) 1 0]);% 得到Q矩阵
            R=[x_best(4)];                              % 得到R矩阵
            assignin('base','Q',Q)                      % 传入基本空间
            assignin('base','R',R)                      % 传入基本空间
            [KK]=lqr(A,B,Q,R);                          % 得到KK值
            KK_yc=KK;                                   
        otherwise
    end
    %% 得到KK值进行仿真
    set(handles.k_lqr1, 'String', num2str(KK(1)));      % 得到KK值并显示在gui中
    set(handles.k_lqr2, 'String', num2str(KK(2)));
    set(handles.k_lqr3, 'String', num2str(KK(3)));
    set(handles.k_lqr4, 'String', num2str(KK(4)));
    set(handles.k_lqr5, 'String', num2str(KK(5)));
    assignin('base','KK',KK)                            % 传入工作空间中
    simOut = sim('step_Bridg','AbsTol','1e-6');         % 使用此KK值进行计算
    t_yc = simOut.find('tout');                         % 得到时间输出
    y_yc = simOut.find('x_out');                        % 得到信号输出
    y_yc=y_yc.signals.values;                           % 得到信号
    assignin('base','y_yc',y_yc)                        % 传入工作空间
    assignin('base','t_yc',t_yc)
    axes(handles.axes3)                                 % 对图窗三进行设置
    %% 做动图显示结果
    cla;                                                % 新建图窗
    n=length(y_yc);                                     % 得到长度
    for i=1:50:n                                        % 循环作图
        cla;                                            % 做新图
        axis on;
        axis([-5 105 -5 78])                            % 对窗格横纵坐标进行设置
        set(gca, 'fontsize', 11, 'fontname', 'times',...
            'fontangle','italic','XMinorTick','on','YMinorTick','on')
        X_M=100/3*y_yc(i,1);                            % 得到当前吊车位置
        X_j=y_yc(i,3);                                  % 得到当前绳子与竖直夹角
        drow_gd;                                        % 调用函数绘制轨道
        drow_dc(X_M);                                   % 调用函数绘制吊车
        drow_wt(X_M,X_j);                               % 调用函数绘制重物
        grid on                                         % 添加栅格
        pause(0.1)                                      % 暂缓0.1秒
        set(gca, 'fontsize', 11, 'fontname', 'times',...
            'fontangle','italic','XMinorTick','on','YMinorTick','on')
    end
%% 函数名称：GA_LQR
%  函数功能：此函数是遗传算法的适应度函数，连接了待求解的自变量以及种群的适应度，
%           这里为了求解出最优的Q矩阵与R矩阵，在我们人工LQR的基础上，设定Q的前
%           三个参数以及R矩阵的参数为自变量进行求解，以位移与预定位置的差值，速
%           度的均方根值以及绳子摆角的均方根值作为适应度函数，求解出最优的参量
function f=GA_LQR(x)
    global wyds;                                    % 声明全局变量
    global time                                     % 声明计算次数
    time=time+1;
    disp(['************第',num2str(time),'次计算*************'])
    %%%%%%%%%%%%%%%%%%% 模型参数设置 %%%%%%%%%%%%%%%%%
    Dm=1000;                                         % 吊车质量(Kg)
    Wm=4000;                                         % 物体质量(Kg)
    l=10;                                            % 绳子长度
    K=1000;                                      	 % 驱动电压放大倍数
    Td=0.001;                                        % 电机时间常数
    g=9.8;                                           % 重力加速度
    A =[ 0 1    0     0      0
         0 0  -39.2   0   0.0010
         0 0    0    1.00    0
         0 0   -4.90  0    0.0001
         0 0     0    0 -100.0000];                  % 得到线性化后的A矩阵
    B =[0;0;0;0;10000];                              % 得到线性化后的B矩阵
    C=eye(5);                                        % 得到线性化后的C矩阵
    D=[0;0;0;0;0];                                   % 得到线性化后的D矩阵
    X_0=100;                                         % 给定最大边界位置
    Q = diag([x(1) x(2) x(3) 1 0]);                  % 得到Q矩阵
    R = [x(3)];                                      % 得到R矩阵
    dqzs=0;                                          % 取噪声强度为0
    [KK]=lqr(A,B,Q,R);                               % 得到KK
    X_yuding=3;                                      % 预定到达3的位置
    %%%%%%%%%%%%%%%%% 传递参数并运行模型 %%%%%%%%%%%%%%%
    assignin('base','A',A);                          % 申明工作空间
    assignin('base','B',B);                          % 将参数传递进Simulink模型
    assignin('base','C',C);
    assignin('base','D',D);
    assignin('base','KK',KK);
    assignin('base','Dm',Dm);
    assignin('base','K',K);
    assignin('base','Wm',Wm);
    assignin('base','l',l);
    assignin('base','g',g);
    assignin('base','X_0',X_0);
    assignin('base','Td',Td);
    assignin('base','dqzs',dqzs);
    [~,~,y1,y2,y3,~,~]=sim('step_Bridg',30);        % 调用simulink进行仿真
    %%%%%%%%%%%%%%%% 对适应度进行设置 %%%%%%%%%%%%%%
    n=length(y1);                                   % 得到输出长度
    err_y1=y1(end-wyds:end)-X_yuding;               % 得到与期望位置的差值
    y1=100*err_y1;                                  % 加权为100
    y1_RMS=sqrt(sum(y1.*y1)/size(y1,1));            % 求得y1的均方根值
    y2_RMS=1/sqrt(sum(y2.*y2)/size(y2,1));          % 求得1/y2的均方根值
    y3_RMS=sqrt(sum(y3.*y3)/size(y3,1));            % 求得y3的均方根值
    f=y1_RMS+y2_RMS+y3_RMS;                         % 得到适应度函数
%% 函数名称：pushbutton2_Callback
%  函数功能：实现对于基本lqr控制的KK值求取以及结果展示
function pushbutton2_Callback(hObject, eventdata, handles)
    %% 定义全局变量并得到输入Q和R值
    global  KK;                                     % 定义全局变量
    global  KK_jb;
    global t;
    global y;
    Q(1)= str2num(get(handles.Q11,'String'));       % 得到输入的Q值
    Q(2)= str2num(get(handles.Q22,'String'));
    Q(3)= str2num(get(handles.Q33,'String'));
    Q(4)= str2num(get(handles.Q44,'String'));
    Q(5)= str2num(get(handles.Q55,'String'));
    Q= diag([Q(1),Q(2),Q(3),Q(4),Q(5)]);            % 得到Q矩阵
    R = str2double(get(handles.R,'String'));        % 得到R矩阵
    %% 得到线性化参数并求解KK
    [A,B,C,D]=linmod('Bridge_crane_system');        % 得到线性化模型参数
    assignin('base','A',A)                          % 输入线性化模型参数
    assignin('base','B',B)
    assignin('base','C',C)
    assignin('base','D',D)
    KK=lqr(A,B,Q,R);                                % 调用lqr函数得到KK值
    %% simulink仿真得到结果
    KK_jb=KK;                                       % 将KK值赋给KK_jb
    set(handles.K1, 'String', num2str(KK(1)));      % 显示KK值
    set(handles.K2, 'String', num2str(KK(2)));
    set(handles.K3, 'String', num2str(KK(3)));
    set(handles.K4, 'String', num2str(KK(4)));
    set(handles.K5, 'String', num2str(KK(5)));
    assignin('base','KK',KK)                        % 传递KK值到基本空间中
    simOut = sim('step_Bridg','AbsTol','1e-5');     % 得到仿真结果
    t = simOut.find('tout');                        % 得到输出时间序列
    y = simOut.find('x_out');                       % 得到输出信号序列
    y=y.signals.values;                             % 得到输出信号值
    assignin('base','y',y)                          % 传递到基本空间
    assignin('base','t',t)
    %% 显示动图
    axes(handles.axes2)                             % 对坐标轴二作图
    cla;                                            % 新建窗格
    n=length(y);                                    % 得到长度
    for i=1:20:n                                    % 循环作图
        cla;                                        % 新建窗格
        axis on;                                    % 坐标轴打开
        axis([-5 105 -5 78])                        % 对窗格横纵坐标进行设置
        set(gca, 'fontsize', 11, 'fontname', 'times',...
            'fontangle','italic','XMinorTick','on','YMinorTick','on')
        X_M=100/3*y(i,1);                           % 得到当前吊车位置
        X_j=y(i,3);                                 % 得到当前绳子与竖直夹角
        drow_gd;                                    % 调用函数绘制轨道
        drow_dc(X_M);                               % 调用函数绘制吊车
        drow_wt(X_M,X_j);                           % 调用函数绘制重物
        grid on                                     % 添加栅格
        pause(0.1)                                  % 暂缓0.1秒
        set(gca, 'fontsize', 11, 'fontname', 'times',...
            'fontangle','italic','XMinorTick','on','YMinorTick','on')
    end
%% 函数名称：pushbutton1_Callback
%  函数功能：实现对于桥式吊车系统的基本参数的设定以及判断系统的能控能观和稳定性
function pushbutton1_Callback(hObject, eventdata, handles)
    %% 得到各项输入并传递入基本空间中
    Dm=str2double(get(handles.Dm,'string'))         % 得到输入的各项参数
    Td=str2double(get(handles.Td,'string'))         % 时间常数
    Wm=str2double(get(handles.Wm,'string'))         % 物体质量
    K=str2double(get(handles.K,'string'))
    l=str2double(get(handles.l,'string'))
    X_0=str2double(get(handles.X_0,'string'))
    X_0=100/3*X_0;
    g=9.8;                                          % 得到重力加速度g
    assignin('base','Dm',Dm)                        % 将参数传递到基本空间中
    assignin('base','Td',Td)
    assignin('base','Wm',Wm) 
    assignin('base','K',K)
    assignin('base','l',l)
    assignin('base','X_0',X_0)
    assignin('base','g',g)
    %% 得到线性化参数并判断系统的各项性能
    [A,B,C,D]=linmod('Bridge_crane_system');        % 得到线性化参数
    sys=ss(A,B,C,D);                                % 得到系统
    p=eig(A);                                       % 得到A矩阵极点
    Tc=ctrb(A,B);                                   % 得到能控性矩阵
    Qc=rank(Tc);                                    % 得到能控性矩阵的秩
    To=ctrb(A,C);                                   % 得到能观性矩阵
    Qo=rank(To);                                    % 得到能观性矩阵的秩
    n=length(A);                                    % 得到系统矩阵的秩
    if sum(real(eig(sys.A))<0)==length(sys.A)       % 如果特征根实部均小于0
        wdpd=['系统稳定'];                           % 系统稳定
    else                                            % 如果特征根实部不是均小于0
        wdpd=['系统不稳定'];                         % 系统不稳定
    end
    if(n==Qc)                                       % 若能控性矩阵满秩
        Tc_flag=['完全能控'];                        % 输出系统能控
    else
        Tc_flag='不完全能控';                        % 输出系统不完全能控
    end
    if(n==Qo)                                       % 若能观性矩阵满秩
        Qc_flag='完全能观';                          % 输出系统能观
    else
        Qc_flag='不完全能观';                        % 系统不完全能观
    end
    %% 回显
    set(handles.wdx, 'String', wdpd);               % 显示系统的稳定性
    set(handles.Qc, 'String', Tc_flag);             % 显示系统的能控性
    set(handles.Qo, 'String', Qc_flag);             % 显示系统的能观性
    set(handles.p1, 'String', num2str(p(1)));
    set(handles.p2, 'String', num2str(p(2)));
    set(handles.p3, 'String', num2str(p(3)));
    set(handles.p4, 'String', num2str(p(4)));
    set(handles.p5, 'String', num2str(p(5)));
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
function R_CreateFcn(hObject, eventdata, handles)
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

function wdx_CreateFcn(hObject, eventdata, handles)
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
function wdx_Callback(hObject, eventdata, handles)
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
