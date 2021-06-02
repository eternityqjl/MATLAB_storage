slCharacterEncoding('UTF-8')

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
    a=imread('frameWork.jpg');                  % 得到a�??1?7
    axes(handles.axes1);                        % 取坐标轴1
    imshow(a);                                  % 显示a�??1?7
    global flag_huitu                           % 是否做子图标�??
    flag_huitu=0;                               % 初�??�为0
    
function varargout = launcher_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;


%% �������ƣ�simulation_Callback
%  �������ܣ�ʵ�ֶ��ڻ���PID���ƺ�ģ��PID���Ƶĸ��������չʾ
function simulation_Callback(hObject, eventdata, handles)
   [A,B,C,D]=linmod('launcher_dir');        % �õ����Ի�����
    sys=ss(A,B,C,D);                                % �õ����Ի�ģ��
    assignin('base','A',A)                          % ���빤���ռ�
    assignin('base','B',B)
    assignin('base','C',C)
    assignin('base','D',D)
    %% �ж�ͼ���Լ��½�ͼ��
    if flag_huitu==1                                % �����ǵ�һ����ͼ
        axes('parent',handles.uipanel11);           % �ؽ�һ��axes
    else
        axes(handles.axes13)                        % ʹ��axes13��ͼ
    end
    flag_huitu=1;                                   % ��Ϊ1
    cla;                                            % �½�ͼ��
    %% ��ȡ�˵���ֵ�������ܼ���
    pop1Value = get(handles.popupmenu1,'value');    % ��ȡ�˵�1��ѡ��
    pop2Value = get(handles.popupmenu2,'value');    % ��ȡ�˵�2��ѡ��
    %% ״̬��ʾ
    if(pop1Value==2&&pop2Value==2)                  % ����LQR����״̬��ʾ
        line='r--';                                 % ѡȡ��ɫ����
        ztxs(t_jb,y_jb,line,0)                      % ��ʹ��hold on ��ͼ
    elseif(pop1Value==3&&pop2Value==2)              % �Ŵ�LQR����״̬��ʾ
        line='b-.';                                 % ѡȡ��ɫ�㻭��
        ztxs(t_yc,y_yc,line,0)                      % ��ʹ��hold on ��ͼ
    elseif(pop1Value==4&&pop2Value==2)              % ����lqr���Ŵ�LQR����״̬�Ա�
        line='r--';
        ztxs(t_jb,y_jb,line,1)                      % ����lqr��ͼ������
        line='b-.';
        ztxs(t_yc,y_yc,line,1)                      % �Ŵ�lqr��ͼ������
        hl=legend('Ordinary','Inheritance');        % ����ͼ��
        set(hl,'Box','off');                        % ȡ���߿�
        set(hl,'Orientation','horizon')             % ������ʾ
        set(hl,'position',[0.3552 0.9537 0.3424 0.0442]);
                                                    % ����ͼ����λ��
        set(hl,'Units','Normalized'...
            ,'FontUnits','Normalized')              % ���Ƿ�ֹ�仯ʱ�������ϴ���α䡣
   %% ����������ԶԱ�
    elseif(pop1Value==2&&pop2Value==3)              % ����LQR���Ƶ�����������ԱȽ�
        line_noline(A,B,C,D,KK_jb)
    elseif(pop1Value==3&&pop2Value==3)              % �Ŵ�LQR���Ƶ�����������ԱȽ�
        line_noline(A,B,C,D,KK_yc)
   %% ³���Է���
    elseif(pop1Value==2&&pop2Value==5)              % ����LQR���Ƶ�³���Է���
        lineStyle = {'b', 'r', 'c', 'y','m','k'};   % ��������
        lbxcs(KK_jb,lineStyle,0);
    elseif(pop1Value==3&&pop2Value==5)              % �Ŵ�LQR���Ƶ�³���Է���
        lineStyle = {'b--', 'r--', 'c--', 'y--','m--','k--'};
                                                    % ��������
        lbxcs(KK_yc,lineStyle,0);
    elseif(pop1Value==4&&pop2Value==5)              % ����lqr���Ŵ�lqr³���ԶԱȷ���
        lineStyle = {'k', 'k', 'k', 'k','k','k'};   % ����lqr����
        lbxcs(KK_jb,lineStyle,1);                   % ��ͼ������
        lineStyle = {'r--', 'r--', 'r--', 'r--','r--','r--'};
        lbxcs(KK_yc,lineStyle,1);
        hl=legend('Ordinary','Inheritance');        % ����ͼ��
        set(hl,'Box','off');                        % ȡ���߿�
        set(hl,'Orientation','horizon')             % ������ʾ
        set(hl,'position',[0.3552 0.9537 0.3424 0.0442]);          
                                                    % ����ͼ����λ��
        set(hl,'Units','Normalized','FontUnits','Normalized')       
                                                    % ���Ƿ�ֹ�仯ʱ�������ϴ���α䡣
    %% ������Ӧ����
    elseif(pop1Value==2&&pop2Value==4)              % ����LQR��������Ӧ����
        zsxyfx(A,B,C,D,KK_jb);
    elseif(pop1Value==3&&pop2Value==4)              % �Ŵ�LQR��������Ӧ����
        zsxyfx(A,B,C,D,KK_yc);
    elseif(pop1Value==4&&pop2Value==4)              % ����LQR���Ŵ�LQR�������Աȷ���
        y_zxjb=zsxyfx(A,B,C,D,KK_jb);               % �õ�����������Ӧ
        y_zxyc=zsxyfx(A,B,C,D,KK_yc);               % �õ��Ŵ�������Ӧ
        t_input=linspace(0,max(t_jb),length(t_jb)); % �õ���Ծ��Ӧʱ��
        zsxy(t_input,y_zxjb,t_input,y_zxyc);        % ��ͼ
        hl=legend('Ordinary','Inheritance');        % ����ͼ��
        set(hl,'Box','off');                        % ��Ҫ�߿�
        set(hl,'Orientation','horizon')             % ������ʾ
        set(hl,'position',[0.3552 0.9537 0.3424 0.0442]);           
                                                    % ����ͼ����λ��
        set(hl,'Units','Normalized','FontUnits','Normalized')       
                                                    % ���Ƿ�ֹ�仯ʱ�������ϴ���α䡣
    end

    
    
%% �������ƣ�zsxyfx ������Ӧ����
%  �������ܣ��������Ի�ģ�Ͳ��������õ������˵����������ͺ�ǿ�Ƚ����������
%  ��������� A,B,C,D��ԭϵͳ���� KK:ʹ��״̬��������  
%  ���������� y_zssy�������������Ӧ����ֵ   
function y_zssy=zsxyfx(A,B,C,D)
        handles = guihandles();                     % �õ����
        pop3Value = get(handles.popupmenu3,'value');% ��ȡ�㷨�������е�ѡ��,����ǿ��
        pop4Value = get(handles.popupmenu4,'value');% ��ȡ�㷨�������е�ѡ��,��������
        global y_jb;                                % ����ȫ�ֱ���, ʱ������
        global t_jb;                                % ��Ծ��Ӧ
        sys=ss(A,B,C,D);                           % �õ�ϵͳ
        n=length(y_jb);                             % �õ�ʱ�����ݳ���
        y_step=10*ones(n,1);                        % �õ���������
        t_input=linspace(0,max(t_jb),n);            % �õ���Ծ��Ӧʱ��
        y_yuanshi = lsim(sys,y_step,t_input);       % ��ü���������������Ӧ����
        switch pop3Value                            % �Բ˵��������ж�
            case 2                                   % ѡ��Ϊ2ʱ����ǿ��Ϊ0
                zsqd = 0;
            case 3                                  % ѡ��Ϊ2ʱ����ǿ��Ϊ0.1
                zsqd = 0.1;
            case 4                                  % ѡ��Ϊ2ʱ����ǿ��Ϊ0.5
                zsqd = 0.5;
            case 5                                  % ѡ��Ϊ2ʱ����ǿ��Ϊ1
                zsqd = 1;
            case 6                                  % ѡ��Ϊ2ʱ����ǿ��Ϊ5
                zsqd = 5;               
            otherwise                               % Ĭ������ǿ��Ϊ0
                zsqd = 0;
        end
        n_gaussian=0;                               % ��ʼ����������ֵ
        switch pop4Value                            % �Բ˵��Ľ����ж�
            case 2                                  % ��˹����
                n_gaussian = zsqd .* randn(n,1);
            case 3                                  % ��˹������
                n_gaussian=wgn(n,1,zsqd);
            case 4
                n_gaussian=-0.2*zsqd*t_input;       % �õ���������
                n_gaussian=(n_gaussian-0.5*min(n_gaussian))';
                                                    % ����������ת��Ϊ�Գ�����
            case 5
                n_gaussian=(zsqd*sin(1000*t_input))';% �õ���������
            case 6
                n_gaussian=0;                       % ѡ��������
            otherwise
                n_gaussian=0;                       % Ĭ��������
        end
        y_input=y_step+n_gaussian;                  % �õ����������������ź�
        y_zssy = lsim(sys,y_input,t_input);         % ��ñջ�ϵͳ�ķ�ֵΪ10�Ľ�Ծ��Ӧ����
        zsxy(t_input,y_yuanshi,t_input,y_zssy);     % ��ͼ
        
%% �������ƣ�zsxy ������Ӧ��ͼ����
%  �������ܣ�������Ҫ��ͼ���������е�ʱ���Լ��źţ���ͼ
%  ��������� t,t1 ����ʱ�� y,y1�����ź� 
 function zsxy(t,y,t1,y1)
    plot(t, y(:,1),'k-', t1, y1(:,1),'r-.')         % ����λ�Ƶ�ͼ��
    title('Displacement')                           % �������
    grid on                                         % ����������
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    
   
%% �������ƣ�ztxs ״̬��ʾ
%  �������ܣ���ʾ��ǰKKֵ��Ӧ��simulink���棬���������ʾ����
%  ���������t,y simulink�ķ�����
%            line:���� hold_flag:�Ƿ񱣳ִ���
function ztxs(t,y,line,hold_flag)
        subplot(321);                               % 做子�??
        if(hold_flag==1)                            % 若hold标志�??            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗�??1?7
        end
        plot(t, y(:,1),line)                        % 做出位移的图�??1?7
        title('Displacement')                       % 加入标题
        grid on                                     % 加入网格�??1?7
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗栛1?7
        subplot(322);                               % 做子�??
        if(hold_flag==1)                            % 若hold标志�??            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗�??1?7
        end
        plot(t, y(:,2),line)                        % 做出图像
        title('speed')                              % 添加速度标�^1?7
        grid on                                     % 加入网格�??1?7
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗栛1?7
        subplot(323);                               % 做子�??
        if(hold_flag==1)                            % 若hold标志�??            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗�??1?7
        end
        plot(t, y(:,3),line)                        % 做���1?7子角度�1?7���??
        title('rope angle')                         % 添加标题
        grid on                                     % 加入网格�??1?7
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗栛1?7
        subplot(324);                               % 做子�??
        if(hold_flag==1)                            % 若hold标志�??            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗�??1?7
        end 
        plot(t, y(:,4),line)                        % 做图�??
        title('rope angle speed')                   % 添加标题
        grid on                                     % 加入网格�??1?7
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗栛1?7
        subplot(313);                               % 做子�??
        if(hold_flag==1)                            % 若hold标志�??            hold on                                 % 保持窗格
        else                                        % hold标志不为1
            hold off                                % 不保持窗�??1?7
        end
        plot(t, y(:,5),line)                        % 做图�??
        title('driving force')                      % 添加标题
        grid on                                     % 加入网格�??1?7
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % 设置图像窗栛1?7
        
        
        
        
%% fuzzyPID_Callback
%  ģ��PID
function fuzzyPID_Callback(hObject, eventdata, handles)
    global time;
    time=0;                                             % 定义计算次数，初值�ٗ1?7    KK_yc=[3.2966 18.1250 -18.9404 -117.5919 0.0001];   % 得到初�????1?7
    pop11Value = get(handles.popupmenu1,'value');      % 获取算法弹出框中的�??��?1?7?1?7
    %% 判断下拉菜单的�??�择，并得到KK�??1?7
    switch pop11Value                                   % �?1?7?��拉菜单进行判�??
        case 1                                          % 默认使用�??优�????1?7
            KK=[3.2966 18.1250 -18.9404 -117.5919 0.0001];
        case 2                                          % 直接使用�??优KK�??1?7
            KK=[3.4966 16.1250 -18.9404 -117.5919 0.0001];
        case 3                                          % 使用ga函数计算KK�??1?7
            
        otherwise
    end
%% �������ƣ�normalPID_Callback
%  �������ܣ�ʵ�ֶ��ڻ���PID���ƵĽ��չʾ
function normalPID_Callback(hObject, eventdata, handles)
    %% ����ȫ�ֱ���
    global  Kp;
    global  Ki;
    global  Kd;
    global  Kpp;
    global  Kip;
    global  Kdp;
    axes(handles.axes2) % ѡ�л�ͼʹ�õ��Ӵ�
    %ϵͳ����
    r = 476.3;
    R = 537.7;
    x0 = 836;
    
    sim('exp4');
    
    R = 500;                   %�뾶
    h = 0.5;                   %Բ���߶�
    m = 100;                   %�ָ��ߵ�����
    [x,y,z] = cylinder(R,m);   %������(0,0)ΪԲ�ģ��߶�Ϊ[0,1]���뾶ΪR��Բ��
    z = h*z;                   %�߶ȷŴ�h��

    surf(x,y,z-255)
    axis([-1.5*R 1.5*R -1.5*R 1.5*R 0 h*50])
    hold on

    plot3([0,0],[0,0],[0,-255])  % 

    thet=ans.simout.data(:,1);   % ����PID��������
    alp = ans.simout.data(:,4);  % ģ��PID��������
    Pc1 =[0,0,0];
    Pc2 = [600,300,0];
    x = [Pc1(1);Pc2(1)];
    y = [Pc1(2);Pc2(2)];
    z = [Pc1(3);Pc2(3)];
    plot3(x,y,z)
    hold on
    h = plot3(x,y,z);
    axis tight equal

    %¼�Ƶ�Ӱ����
    n = min(length(thet),length(alp));
    n
    M = moviein(n);
    for j=1:1000:n
        axis([-600 600 -600 600 -400  400]);
        rotate(h,[1 0 0],alp(j,:),[0,0,0])  % �˶�ѧ���� pitch ��
        rotate(h,[0 0 1],thet(j,:),[0,0,0]) % �˶�ѧ���� yaw ��
        M(:, j) = getframe;
    end
    axis tight equal
%% �������ƣ�pushbutton1_Callback
%  �������ܣ�ʵ�ֶ���ϵͳ�Ļ����������趨�Լ��ж�ϵͳ���ܿ��ܹۺ��ȶ���????
function pushbutton1_Callback(hObject, eventdata, handles)
    %% �õ��������벢����������ռ���
    Dm=str2double(get(handles.Dm,'string'))         % �õ�����ĸ������
    Cm=str2double(get(handles.Cm,'string'))         % ��й©ϵ��
    Jt=str2double(get(handles.Jt,'string'))         % �ܹ���
    Vm=str2double(get(handles.Vm,'string'))         % ���ݻ�
    Ka=str2double(get(handles.Ka,'string'))         % ����λ�ƿ��Ʊ���
    betae=str2double(get(handles.betae,'string'))   % ����ģ��
    M1=str2double(get(handles.M1,'string'))         % ��������
    Kq=str2double(get(handles.Kq,'string'))         % ����ģ��
    Kc=str2double(get(handles.Kc,'string'))         % ��������
    
    Kce = Kc + Cm;
    omegah = sqrt(4*betae*Dm^2/(Vm*Jt));
    xih = Kce/Dm * sqrt(betae*Jt/Vm);                
    
    num = [Ka*Kq/Dm];                               % ϵͳ���ݺ���
    den = [1/omegah^2, 2*xih/omegah, 1, 0];
    
    [A, B, C, D] = tf2ss(num, den)                  % ���ݺ���ת״̬�ռ�
    
    %% ���빤���ռ�
    assignin('base','Dm',Dm)                        
    assignin('base','Cm',Cm)
    assignin('base','Jt',Jt) 
    assignin('base','Vm',Vm)
    assignin('base','Ka',Ka)
    assignin('base','betae',betae)
    assignin('base','M1',M1)
    assignin('base','Kq',Kc)
    assignin('base','Kc',Kq)
    
    sys=ss(A,B,C,D);                                % ���빤���ռ�
    p=eig(A);                                       % ��ȡ����ֵ
    Tc=ctrb(A,B);                                   % �ɿ��Ծ���
    Qc=rank(Tc);                                    % ����
    To=obsv(A,C);                                   % �ɹ��Ծ���
    Qo=rank(To);                                    % ����
    n=length(A);                                    % ��״̬�������
    if sum(real(eig(sys.A))<0)==length(sys.A)       % �ж�ϵͳ�ȶ���
        stable_or_not=['ϵͳ�ȶ�'];                           % ϵͳ�ȶ�
    else                                            % ��״̬���������ֵ����0
        stable_or_not=['ϵͳ���ȶ�'];                         % ϵͳ���ȶ�
    end
    if(n==Qc)                                       % �ɿؾ�������
        Tc_flag=['��ȫ�ܿ�'];                        % ϵͳ��ȫ�ܿ�
    else
        Tc_flag=['����ȫ�ܿ�'];                        % ϵͳ����ȫ�ܿ�
    end
    if(n==Qo)                                       % �ɹ۾�������
        Qc_flag='��ȫ�ܹ�';                          % ϵͳ��ȫ�ܹ�
    else
        Qc_flag='����ȫ�ܹ�';                        % ϵͳ����ȫ�ܹ�
    end
    %% ����
    set(handles.stable, 'String', stable_or_not);               % ��ʾϵͳ���ȶ���
    set(handles.Qc, 'String', Tc_flag);             % ��ʾϵͳ���ܿ���
    set(handles.Qo, 'String', Qc_flag);             % ��ʾϵͳ���ܹ���
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
    fis = readfis('./Fuzzy.fis') % ��ȡģ�����ļ�
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
    set(handles.Kp, 'String', 5.0);             % �Ƽ������������ڵ�ϵ��
    set(handles.Ki, 'String', 0.2);             % �Ƽ��������ֻ��ڵ�ϵ��
    set(handles.Kd, 'String', 0.1);             % �Ƽ�����΢�ֻ��ڵ�ϵ��
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
    rules1=imread('rules1.jpg');                  % ��������ͼ��
    rules2=imread('rules2.jpg');                  % ��������ͼ��
    rules3=imread('rules3.jpg');                  % ��������ͼ��
    rules4=imread('rules4.jpg');                  % ��������ͼ��
    axes(handles.axes3);                        % ָ���Ӵ�3
    subplot(411)
    imshow(rules1);                              % չʾ�����
    subplot(412)
    imshow(rules2);                              % չʾ�����
    subplot(413)
    imshow(rules3);                              % չʾ�����
    subplot(414)
    imshow(rules4);                              % չʾ�����
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
