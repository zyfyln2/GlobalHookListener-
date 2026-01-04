function [] = pressF9(fcn)
% 按下f9执行代码
% if evalin("base", ...
%         'exist("IISSAA","var")')
%     IISSAA = evalin('base', 'IISSAA');
% else
IISSAA=GlobalHookListener();
assignin("base","IISSAA",IISSAA);
% end
IISSAA.doifpressed({'VcF9'},fcn);
IISSAA.start
end