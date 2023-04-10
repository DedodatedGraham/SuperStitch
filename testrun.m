clear
clc
timerstart = tic;
if ispc()%if Windows
    SuperStitch("brokenImg\",10,100);
else%Linux/Mac
    SuperStitch("brokenImg/",10,100);
end
timerend = toc(timerstart);
disp(append('Total Time: ',string(floor(timerend/60)),' (m)',string(mod(timerend,60)),' (s)'));
