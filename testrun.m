clear
clc
timerstart = tic;
if ispc()%if Windows
    TestSuperStitch("\input\brokenImg\",15,60);
else%Linux/Mac
    SuperStitch("/src/camera/","data/translation_run_4_24_9_38.txt","data/translation_run_4_24_9_38_pos.txt");
end
timerend = toc(timerstart);
disp(append('Total Time: ',string(floor(timerend/60)),' (m)',string(mod(timerend,60)),' (s)'));
