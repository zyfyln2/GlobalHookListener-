% doifpressed函数 - 注册热键

% GlobalHookListener().doifpressed({'VcLeftControl', 'VcF9'}, fcn)
function doifpressed(listener,hotkeys, fcn)
% DOIFPRESSED 注册热键和对应的回调函数
% hotkeys: 热键组合的元胞数组，如 {'VcLeftControl', 'VcAlt', 'F'}
% fcn: 当热键同时按下时要执行的函数句柄

% doifpressed({'VcLeftControl', 'VcF9'}, fcn)
% 创建监听器
listener.stop
% 设置默认回调函数
listener.KeyPressCallback = @handleKeyPress;
listener.KeyReleaseCallback = @handleKeyRelease;
% 添加到热键配置
listener.UserData.hotkeyConfig ={hotkeys, fcn} ;

% 初始化这些按键的状态
for i = 1:length(hotkeys)
    keyName = hotkeys{i};
    stateName = keyName;
    listener.UserData.(stateName) = false;
end
% 显示已注册的热键
fprintf('注册热键: ');
for i = 1:length(hotkeys)
    if i > 1
        fprintf('+');
    end
    fprintf('%s', strrep(hotkeys{i}, 'Vc', ''));
end
% 启动监听
listener.start();
fprintf('热键监听已启动，按ESC停止监听\n');
end

% 键盘按下回调函数
function handleKeyPress(listener, e)
keyCode = e.KeyCode;
% ESC键停止监听
if strcmp(keyCode, 'VcEscape')
    listener.stop();
    fprintf('监听已停止\n');
    return;
end

% 更新按键状态
stateName = [keyCode];
% 检查每个热键组合
if isfield(listener.UserData, 'hotkeyConfig')
    hotkeyConfig = listener.UserData.hotkeyConfig;
end

if isfield(listener.UserData, stateName)
    listener.UserData.(stateName) = true;
    tmpUS=listener.UserData;
    keys = hotkeyConfig{1};
    callbackFunc = hotkeyConfig{2};
    % 检查是否按下了当前热键的最后一个键
    % 检查所有修饰键是否都已按下-1
    allPressed = true;
    for j = 1:length(keys)
        stateName = keys{j};
        if ~isfield(listener.UserData, stateName) || ...
                (~tmpUS.(stateName))
            allPressed = false;
            break;
        end
    end
    % 如果所有键都同时按下，执行回调
    if allPressed
        try;
            callbackFunc();
        catch ME
            warning('热键回调执行失败: %s');
        end
    end
end
end

% 键盘释放回调函数
function handleKeyRelease(listener, e)
keyCode = e.KeyCode;
% 更新按键状态
stateName = [keyCode];
if isfield(listener.UserData, stateName)
    listener.UserData.(stateName) = false;
end
end