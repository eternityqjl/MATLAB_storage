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
    a=imread('frameWork.jpg');                  % �õ�aͼ
    axes(handles.axes1);                        % ȡ������1
    imshow(a);                                  % ��ʾaͼ
    global flag_huitu                           % �Ƿ�����ͼ��־
    flag_huitu=0;                               % ��ֵΪ0
    
function varargout = tgb_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;

%% �������ƣ�pushbutton4_Callback
%  �������ܣ�ʵ�ֶ��ڻ���lqr���ƺ��Ŵ�lqr���Ƶĸ��������չʾ
function pushbutton4_Callback(hObject, eventdata, handles)
    handles = guihandles();                         % ��þ��
    global t_jb;                                    % ����ȫ�ֱ���
    global y_jb;
    global KK_jb;
    global t_yc;
    global y_yc
    global KK_yc;
    global flag_huitu
    %% �õ�����lqr���Ƶķ�������
    KK=KK_jb;                                       % �õ�����lqrKKֵ
    assignin('base','KK',KK)                        % ������������ռ�
    simOut = sim('step_Bridg','AbsTol','1e-6');     % �õ���������
    t_jb = simOut.find('tout');                     % �õ�ʱ�����
    y_jb = simOut.find('x_out');                    % �õ��������
    y_jb=y_jb.signals.values;                       % �õ�����ź�
    assignin('base','y_jb',y_jb)                    % ������������ռ�
    assignin('base','t_jb',t_jb)
    %% �õ��Ŵ�lqr���Ƶķ�������
    KK=KK_yc;                                       % �õ��Ŵ�lqrKKֵ
    assignin('base','KK',KK)                        % ������������ռ�
    simOut = sim('step_Bridg','AbsTol','1e-6');     % �õ���������
    t_yc = simOut.find('tout');                     % �õ�ʱ�����
    y_yc = simOut.find('x_out');                    % �õ��������
    y_yc=y_yc.signals.values;                       % �õ�����ź�
    assignin('base','y_yc',y_yc)                    % ������������ռ�
    assignin('base','t_yc',t_yc)
    %% �õ��������Ի�ģ�Ͳ���
    [A,B,C,D]=linmod('Bridge_crane_system');        % �õ����Ի�����
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
function y_zssy=zsxyfx(A,B,C,D,KK)
        handles = guihandles();                     % �õ����
        pop3Value = get(handles.popupmenu3,'value');% ��ȡ�㷨�������е�ѡ��
        pop4Value = get(handles.popupmenu4,'value');% ��ȡ�㷨�������е�ѡ��
        global y_jb;                                % ����ȫ�ֱ���
        global t_jb;
        AA=A-B*KK;                                  % �õ����������ϵͳ
        sys=ss(AA,B,C,D);                           % �õ�ϵͳ
        n=length(y_jb);                             % �õ�ʱ�����ݳ���
        y_step=10*ones(n,1);                        % �õ���������
        t_input=linspace(0,max(t_jb),n);            % �õ���Ծ��Ӧʱ��
        y_yuanshi = lsim(sys,y_step,t_input);       % ��ü���������������Ӧ����
        switch pop3Value                            % �Բ˵��������ж�
            case 2                                  % ѡ��Ϊ2ʱ����ǿ��Ϊ0
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
    subplot(321)                                    % ����ͼ
    plot(t, y(:,1),'k-', t1, y1(:,1),'r-.')         % ����λ�Ƶ�ͼ��
    title('Displacement')                           % �������
    grid on                                         % ����������
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    subplot(322)                                    % ����ͼ
    plot(t, y(:,2),'k-',t1, y1(:,2),'r-.')          % ����ͼ��
    title('speed')                                  % ����ٶȱ���
    grid on                                         % ����������
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    subplot(323)                                    % ����ͼ
    plot(t, y(:,3),'k-', t1, y1(:,3),'r-.')         % �����ӽǶ�ͼ��
    title('rope angle')                             % ��ӱ���
    grid on                                         % ����������
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    subplot(324)                                    % ����ͼ
    plot(t, y(:,4),'k-', t1, y1(:,4),'r-.')         % ��ͼ��
    title('rope angle speed')                       % ��ӱ���
    grid on                                         % ����������
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    subplot(313)                                    % ����ͼ
    plot(t, y(:,5),'k-', t1, y1(:,5),'r-.')         % ��ͼ��
    title('driving force')                          % ��ӱ���
    grid on                                         % ����������
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    hl=legend('Original response','Noise response');% ���ͼ��
    set(hl,'Box','off');                            % �����ޱ߿�
    set(hl,'Orientation','horizon')                 % ���ú�����ʾ
    set(hl,'position',[0.3252 0.9556 0.4529 0.0445]);% ����ͼ����λ��
    set(hl,'Units','Normalized','FontUnits','Normalized')
                                                    % ���Ƿ�ֹ�仯ʱ�������ϴ���α䡣
%% �������ƣ�ztxs ״̬��ʾ
%  �������ܣ���ʾ��ǰKKֵ��Ӧ��simulink���棬���������ʾ����
%  ���������t,y simulink�ķ�����
%            line:���� hold_flag:�Ƿ񱣳ִ���
function ztxs(t,y,line,hold_flag)
        subplot(321);                               % ����ͼ
        if(hold_flag==1)                            % ��hold��־Ϊ1
            hold on                                 % ���ִ���
        else                                        % hold��־��Ϊ1
            hold off                                % �����ִ���
        end
        plot(t, y(:,1),line)                        % ����λ�Ƶ�ͼ��
        title('Displacement')                       % �������
        grid on                                     % ����������
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % ����ͼ�񴰸�
        subplot(322);                               % ����ͼ
        if(hold_flag==1)                            % ��hold��־Ϊ1
            hold on                                 % ���ִ���
        else                                        % hold��־��Ϊ1
            hold off                                % �����ִ���
        end
        plot(t, y(:,2),line)                        % ����ͼ��
        title('speed')                              % ����ٶȱ���
        grid on                                     % ����������
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % ����ͼ�񴰸�
        subplot(323);                               % ����ͼ
        if(hold_flag==1)                            % ��hold��־Ϊ1
            hold on                                 % ���ִ���
        else                                        % hold��־��Ϊ1
            hold off                                % �����ִ���
        end
        plot(t, y(:,3),line)                        % �����ӽǶ�ͼ��
        title('rope angle')                         % ��ӱ���
        grid on                                     % ����������
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % ����ͼ�񴰸�
        subplot(324);                               % ����ͼ
        if(hold_flag==1)                            % ��hold��־Ϊ1
            hold on                                 % ���ִ���
        else                                        % hold��־��Ϊ1
            hold off                                % �����ִ���
        end 
        plot(t, y(:,4),line)                        % ��ͼ��
        title('rope angle speed')                   % ��ӱ���
        grid on                                     % ����������
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % ����ͼ�񴰸�
        subplot(313);                               % ����ͼ
        if(hold_flag==1)                            % ��hold��־Ϊ1
            hold on                                 % ���ִ���
        else                                        % hold��־��Ϊ1
            hold off                                % �����ִ���
        end
        plot(t, y(:,5),line)                        % ��ͼ��
        title('driving force')                      % ��ӱ���
        grid on                                     % ����������
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % ����ͼ�񴰸�
%% �������ƣ�line_noline
%  �������ܣ��˺����Ǵ���ԭϵͳ�Ĳ����Լ�״̬��������Ĳ�����������Ի��Լ������Ի�
%           ��ϵͳ�ķ�ֵΪ10�Ľ�Ծ������Ӧ����
%  ��������� A,B,C,D��ԭϵͳ���� KK:��õ�״̬��������
function line_noline(A,B,C,D,KK)
    KK=KK;
    assignin('base','KK',KK);
    %% ���ȸ���Q��R����״̬��������K 
    [t,y]=sim('step_Bridg',30);                     % �õ��ķ�������
    n=length(t);                                    % �õ�ʱ��ĳ���
    maxT = t(n);                                    % ʹ��״̬����K����ԭ���׵����ڣ���õ�λ��Ծ��Ӧ����
    %% �������Ի�ģ�͵ıջ�ϵͳ
    AA = A-B*KK;                                    % �õ����뷴�������ϵͳ����
    sys1 = ss(AA, B, C, D);                         % �õ��µ�ϵͳ
    t_step=linspace(0,maxT,n);                      % �õ���Ծ��Ӧʱ��
    y_step = 10*ones(1,n);                          % �õ���Ծ��Ӧ��ֵ
    y1 = lsim(sys1,y_step,t_step);                  % ��ñջ�ϵͳ�ķ�ֵΪ10�Ľ�Ծ��Ӧ����
    %% �Ա�K�����Ի�ϵͳ��ԭϵͳ�Ŀ���Ч��
    subplot(321)                                    % ����ͼ
    plot(t, y(:,1), t_step, y1(:,1))                % ����λ�Ƶ�ͼ��
    title('Displacement')                           % �������                      
    grid on                                         % ����������
                                                    % ���ͼ��
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    subplot(322)                                    % ����ͼ
    plot(t, y(:,2), t_step, y1(:,2))                % ����ͼ��
    title('speed')                                  % ����ٶȱ���
    grid on                                         % ����������
                                                    % ���ͼ��
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    subplot(323)                                    % ����ͼ
    plot(t, y(:,3), t_step, y1(:,3))                % �����ӽǶ�ͼ��
    title('rope angle')                             % ��ӱ���
    grid on                                         % ����������
                                                    % ���ͼ��
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    subplot(324)                                    % ����ͼ
    plot(t, y(:,4), t_step, y1(:,4))                % ��ͼ��
    title('rope angle speed')                       % ��ӱ���
    grid on                                         % ����������
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    subplot(313)                                    % ����ͼ
    plot(t, y(:,5), t_step, y1(:,5))                % ��ͼ��
    title('driving force')                          % ��ӱ���
    grid on                                         % ����������
    set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
        'times','fontangle','italic','XMinorTick'...
        ,'on','YMinorTick','on')                    % ����ͼ�񴰸�
    hl=legend('Nonlinear','Linear');                % ���ͼ��
    set(hl,'Box','off');                            % �����ޱ߿�
    set(hl,'Orientation','horizon')                 % ���ú�����ʾ
    set(hl,'position',[0.3331 0.9516 0.3424 0.0442]);% ����ͼ����λ��
    set(hl,'Units','Normalized','FontUnits','Normalized')   
                                                    % ���Ƿ�ֹ�仯ʱ�������ϴ���α䡣
%% �������ƣ�lbxcs ³���Է���
%  �������ܣ��˺�����ͨ���ı�ϵͳ�������ȣ��̶��������������䣬�ı������������
%           �Ӷ��ı��������Բ���ϵͳ��³���ԡ�
function lbxcs(KK,lineStyle,hold_flag)
    KK=KK;              
    assignin('base','KK',KK);
    %% ���Ե�ǰK��ģ�Ͳ����仯��³����
    wrs = [0.1 1 4 10 40 100];                      % ���������������
    W0 = 1000;                                      % �������������������ͬ
    for i=1:6
        Wm = W0 *wrs(i);                            % ����������
        assignin('base','Wm',Wm);
        [t1,y1]=sim('step_Bridg',30);               % �õ���������
        subplot(3,2,i)                              % ����ͼ
        if(hold_flag==1)                            % ��hold��־Ϊ1
            hold on                                 % ���ִ���
        else                                        % hold��־��Ϊ1
            hold off                                % �����ִ���
        end
        plot(t1, y1(:,1), lineStyle{i})             % ��ͼ
        grid on                                     % ����������
        title(sprintf('Displacement mass ratio=%4.2f',wrs(i)))
                                                    % ���ϱ���
        set(gca, 'linewidth', 0.9, 'fontsize', 9, 'fontname', ...
            'times','fontangle','italic','XMinorTick'...
            ,'on','YMinorTick','on')                % ��ͼ�񴰸��������
    end
%% �������ƣ�pushbutton3_Callback
%  �������ܣ�ʵ�ֶ����Ŵ�lqr���Ƶ�KKֵ�����
function pushbutton3_Callback(hObject, eventdata, handles)
    global KK_yc;                                       % ����ȫ�ֱ���
    global wyds;
    global time;
    time=0;                                             % ��������������ֵΪ0
    KK_yc=[3.2966 18.1250 -18.9404 -117.5919 0.0001];   % �õ���ֵ
    pop11Value = get(handles.popupmenu11,'value');      % ��ȡ�㷨�������е�ѡ��
    %% �ж������˵���ѡ�񣬲��õ�KKֵ
    switch pop11Value                                   % �������˵������ж�
        case 1                                          % Ĭ��ʹ������ֵ
            KK=[3.2966 18.1250 -18.9404 -117.5919 0.0001];
        case 2                                          % ֱ��ʹ������KKֵ
            KK=[3.4966 16.1250 -18.9404 -117.5919 0.0001];
        case 3                                          % ʹ��ga��������KKֵ
            %% ʹ���Ŵ��㷨�������KKֵ
            [A,B,C,D] = linmod('Bridge_crane_system');  % ʹ��linmod���Ի��Ľ��
            ycds= str2num(get(handles.ycds,'String'));  % �Ŵ�����
            jygs= str2num(get(handles.jygs,'String'));  % ��Ӣ����
            zqdx= str2num(get(handles.zqdx,'String'));  % ��Ⱥ��С
            bygl= str2num(get(handles.bygl,'String'));  % �������
            wyds= str2num(get(handles.wyds,'String'));  % λ�Ƶ���
            assignin('base','ycds',ycds)                % ���������ݵ�simulink��
            assignin('base','jygs',jygs)                
            assignin('base','zqdx',zqdx)
            assignin('base','bygl',bygl)
            assignin('base','wyds',wyds)
            fitnessfcn = @GA_LQR;                       % ��Ӧ�Ⱥ������
            nvars=4;                                    % ����ı�����Ŀ
            LB = 0.1*ones(1,4);                         % ����
            UB = 20*ones(1,4);                          % ����
            options=gaoptimset('PopulationSize',zqdx,'PopInitRange',...
                [LB;UB],'EliteCount',jygs,'CrossoverFraction',bygl,...
                'Generations',ycds,'StallGenLimit',5,'TolFun',...
                1e-100,'PlotFcns',{@gaplotbestf,@gaplotbestindiv});
                                                        %��������
            [x_best,fval]=ga(fitnessfcn,nvars, [],[],[],[],LB,UB,[],options);
                                                        % ����ga��������
            assignin('base','x_best',x_best)
            Q=diag([x_best(1) x_best(2) x_best(3) 1 0]);% �õ�Q����
            R=[x_best(4)];                              % �õ�R����
            assignin('base','Q',Q)                      % ��������ռ�
            assignin('base','R',R)                      % ��������ռ�
            [KK]=lqr(A,B,Q,R);                          % �õ�KKֵ
            KK_yc=KK;                                   
        otherwise
    end
    %% �õ�KKֵ���з���
    set(handles.k_lqr1, 'String', num2str(KK(1)));      % �õ�KKֵ����ʾ��gui��
    set(handles.k_lqr2, 'String', num2str(KK(2)));
    set(handles.k_lqr3, 'String', num2str(KK(3)));
    set(handles.k_lqr4, 'String', num2str(KK(4)));
    set(handles.k_lqr5, 'String', num2str(KK(5)));
    assignin('base','KK',KK)                            % ���빤���ռ���
    simOut = sim('step_Bridg','AbsTol','1e-6');         % ʹ�ô�KKֵ���м���
    t_yc = simOut.find('tout');                         % �õ�ʱ�����
    y_yc = simOut.find('x_out');                        % �õ��ź����
    y_yc=y_yc.signals.values;                           % �õ��ź�
    assignin('base','y_yc',y_yc)                        % ���빤���ռ�
    assignin('base','t_yc',t_yc)
    axes(handles.axes3)                                 % ��ͼ������������
    %% ����ͼ��ʾ���
    cla;                                                % �½�ͼ��
    n=length(y_yc);                                     % �õ�����
    for i=1:50:n                                        % ѭ����ͼ
        cla;                                            % ����ͼ
        axis on;
        axis([-5 105 -5 78])                            % �Դ�����������������
        set(gca, 'fontsize', 11, 'fontname', 'times',...
            'fontangle','italic','XMinorTick','on','YMinorTick','on')
        X_M=100/3*y_yc(i,1);                            % �õ���ǰ����λ��
        X_j=y_yc(i,3);                                  % �õ���ǰ��������ֱ�н�
        drow_gd;                                        % ���ú������ƹ��
        drow_dc(X_M);                                   % ���ú������Ƶ���
        drow_wt(X_M,X_j);                               % ���ú�����������
        grid on                                         % ���դ��
        pause(0.1)                                      % �ݻ�0.1��
        set(gca, 'fontsize', 11, 'fontname', 'times',...
            'fontangle','italic','XMinorTick','on','YMinorTick','on')
    end
%% �������ƣ�GA_LQR
%  �������ܣ��˺������Ŵ��㷨����Ӧ�Ⱥ����������˴������Ա����Լ���Ⱥ����Ӧ�ȣ�
%           ����Ϊ���������ŵ�Q������R�����������˹�LQR�Ļ����ϣ��趨Q��ǰ
%           ���������Լ�R����Ĳ���Ϊ�Ա���������⣬��λ����Ԥ��λ�õĲ�ֵ����
%           �ȵľ�����ֵ�Լ����Ӱڽǵľ�����ֵ��Ϊ��Ӧ�Ⱥ������������ŵĲ���
function f=GA_LQR(x)
    global wyds;                                    % ����ȫ�ֱ���
    global time                                     % �����������
    time=time+1;
    disp(['************��',num2str(time),'�μ���*************'])
    %%%%%%%%%%%%%%%%%%% ģ�Ͳ������� %%%%%%%%%%%%%%%%%
    Dm=1000;                                         % ��������(Kg)
    Wm=4000;                                         % ��������(Kg)
    l=10;                                            % ���ӳ���
    K=1000;                                      	 % ������ѹ�Ŵ���
    Td=0.001;                                        % ���ʱ�䳣��
    g=9.8;                                           % �������ٶ�
    A =[ 0 1    0     0      0
         0 0  -39.2   0   0.0010
         0 0    0    1.00    0
         0 0   -4.90  0    0.0001
         0 0     0    0 -100.0000];                  % �õ����Ի����A����
    B =[0;0;0;0;10000];                              % �õ����Ի����B����
    C=eye(5);                                        % �õ����Ի����C����
    D=[0;0;0;0;0];                                   % �õ����Ի����D����
    X_0=100;                                         % �������߽�λ��
    Q = diag([x(1) x(2) x(3) 1 0]);                  % �õ�Q����
    R = [x(3)];                                      % �õ�R����
    dqzs=0;                                          % ȡ����ǿ��Ϊ0
    [KK]=lqr(A,B,Q,R);                               % �õ�KK
    X_yuding=3;                                      % Ԥ������3��λ��
    %%%%%%%%%%%%%%%%% ���ݲ���������ģ�� %%%%%%%%%%%%%%%
    assignin('base','A',A);                          % ���������ռ�
    assignin('base','B',B);                          % ���������ݽ�Simulinkģ��
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
    [~,~,y1,y2,y3,~,~]=sim('step_Bridg',30);        % ����simulink���з���
    %%%%%%%%%%%%%%%% ����Ӧ�Ƚ������� %%%%%%%%%%%%%%
    n=length(y1);                                   % �õ��������
    err_y1=y1(end-wyds:end)-X_yuding;               % �õ�������λ�õĲ�ֵ
    y1=100*err_y1;                                  % ��ȨΪ100
    y1_RMS=sqrt(sum(y1.*y1)/size(y1,1));            % ���y1�ľ�����ֵ
    y2_RMS=1/sqrt(sum(y2.*y2)/size(y2,1));          % ���1/y2�ľ�����ֵ
    y3_RMS=sqrt(sum(y3.*y3)/size(y3,1));            % ���y3�ľ�����ֵ
    f=y1_RMS+y2_RMS+y3_RMS;                         % �õ���Ӧ�Ⱥ���
%% �������ƣ�pushbutton2_Callback
%  �������ܣ�ʵ�ֶ��ڻ���lqr���Ƶ�KKֵ��ȡ�Լ����չʾ
function pushbutton2_Callback(hObject, eventdata, handles)
    %% ����ȫ�ֱ������õ�����Q��Rֵ
    global  KK;                                     % ����ȫ�ֱ���
    global  KK_jb;
    global t;
    global y;
    Q(1)= str2num(get(handles.Q11,'String'));       % �õ������Qֵ
    Q(2)= str2num(get(handles.Q22,'String'));
    Q(3)= str2num(get(handles.Q33,'String'));
    Q(4)= str2num(get(handles.Q44,'String'));
    Q(5)= str2num(get(handles.Q55,'String'));
    Q= diag([Q(1),Q(2),Q(3),Q(4),Q(5)]);            % �õ�Q����
    R = str2double(get(handles.R,'String'));        % �õ�R����
    %% �õ����Ի����������KK
    [A,B,C,D]=linmod('Bridge_crane_system');        % �õ����Ի�ģ�Ͳ���
    assignin('base','A',A)                          % �������Ի�ģ�Ͳ���
    assignin('base','B',B)
    assignin('base','C',C)
    assignin('base','D',D)
    KK=lqr(A,B,Q,R);                                % ����lqr�����õ�KKֵ
    %% simulink����õ����
    KK_jb=KK;                                       % ��KKֵ����KK_jb
    set(handles.K1, 'String', num2str(KK(1)));      % ��ʾKKֵ
    set(handles.K2, 'String', num2str(KK(2)));
    set(handles.K3, 'String', num2str(KK(3)));
    set(handles.K4, 'String', num2str(KK(4)));
    set(handles.K5, 'String', num2str(KK(5)));
    assignin('base','KK',KK)                        % ����KKֵ�������ռ���
    simOut = sim('step_Bridg','AbsTol','1e-5');     % �õ�������
    t = simOut.find('tout');                        % �õ����ʱ������
    y = simOut.find('x_out');                       % �õ�����ź�����
    y=y.signals.values;                             % �õ�����ź�ֵ
    assignin('base','y',y)                          % ���ݵ������ռ�
    assignin('base','t',t)
    %% ��ʾ��ͼ
    axes(handles.axes2)                             % �����������ͼ
    cla;                                            % �½�����
    n=length(y);                                    % �õ�����
    for i=1:20:n                                    % ѭ����ͼ
        cla;                                        % �½�����
        axis on;                                    % �������
        axis([-5 105 -5 78])                        % �Դ�����������������
        set(gca, 'fontsize', 11, 'fontname', 'times',...
            'fontangle','italic','XMinorTick','on','YMinorTick','on')
        X_M=100/3*y(i,1);                           % �õ���ǰ����λ��
        X_j=y(i,3);                                 % �õ���ǰ��������ֱ�н�
        drow_gd;                                    % ���ú������ƹ��
        drow_dc(X_M);                               % ���ú������Ƶ���
        drow_wt(X_M,X_j);                           % ���ú�����������
        grid on                                     % ���դ��
        pause(0.1)                                  % �ݻ�0.1��
        set(gca, 'fontsize', 11, 'fontname', 'times',...
            'fontangle','italic','XMinorTick','on','YMinorTick','on')
    end
%% �������ƣ�pushbutton1_Callback
%  �������ܣ�ʵ�ֶ�����ʽ����ϵͳ�Ļ����������趨�Լ��ж�ϵͳ���ܿ��ܹۺ��ȶ���
function pushbutton1_Callback(hObject, eventdata, handles)
    %% �õ��������벢����������ռ���
    Dm=str2double(get(handles.Dm,'string'))         % �õ�����ĸ������
    Td=str2double(get(handles.Td,'string'))         % ʱ�䳣��
    Wm=str2double(get(handles.Wm,'string'))         % ��������
    K=str2double(get(handles.K,'string'))
    l=str2double(get(handles.l,'string'))
    X_0=str2double(get(handles.X_0,'string'))
    X_0=100/3*X_0;
    g=9.8;                                          % �õ��������ٶ�g
    assignin('base','Dm',Dm)                        % ���������ݵ������ռ���
    assignin('base','Td',Td)
    assignin('base','Wm',Wm) 
    assignin('base','K',K)
    assignin('base','l',l)
    assignin('base','X_0',X_0)
    assignin('base','g',g)
    %% �õ����Ի��������ж�ϵͳ�ĸ�������
    [A,B,C,D]=linmod('Bridge_crane_system');        % �õ����Ի�����
    sys=ss(A,B,C,D);                                % �õ�ϵͳ
    p=eig(A);                                       % �õ�A���󼫵�
    Tc=ctrb(A,B);                                   % �õ��ܿ��Ծ���
    Qc=rank(Tc);                                    % �õ��ܿ��Ծ������
    To=ctrb(A,C);                                   % �õ��ܹ��Ծ���
    Qo=rank(To);                                    % �õ��ܹ��Ծ������
    n=length(A);                                    % �õ�ϵͳ�������
    if sum(real(eig(sys.A))<0)==length(sys.A)       % ���������ʵ����С��0
        wdpd=['ϵͳ�ȶ�'];                           % ϵͳ�ȶ�
    else                                            % ���������ʵ�����Ǿ�С��0
        wdpd=['ϵͳ���ȶ�'];                         % ϵͳ���ȶ�
    end
    if(n==Qc)                                       % ���ܿ��Ծ�������
        Tc_flag=['��ȫ�ܿ�'];                        % ���ϵͳ�ܿ�
    else
        Tc_flag='����ȫ�ܿ�';                        % ���ϵͳ����ȫ�ܿ�
    end
    if(n==Qo)                                       % ���ܹ��Ծ�������
        Qc_flag='��ȫ�ܹ�';                          % ���ϵͳ�ܹ�
    else
        Qc_flag='����ȫ�ܹ�';                        % ϵͳ����ȫ�ܹ�
    end
    %% ����
    set(handles.wdx, 'String', wdpd);               % ��ʾϵͳ���ȶ���
    set(handles.Qc, 'String', Tc_flag);             % ��ʾϵͳ���ܿ���
    set(handles.Qo, 'String', Qc_flag);             % ��ʾϵͳ���ܹ���
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
