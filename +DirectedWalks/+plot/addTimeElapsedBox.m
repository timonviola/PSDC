function [objH,t] = addTimeElapsedBox(fig)
t = tic;
elapsedTime = util.getTimeElapsed(t);
objH = annotation(fig,...
    'textbox',...
    [0.69 0.12 0.21 0.08],...
    'String', ['Elapsed time: ' elapsedTime],...
    'EdgeColor', [.75 .75 .75],...
    'FontName','Consolas',...
    'Tag','etBox');

% To display the time continously I would need a custom class.