clear
clc
if ispc()%if Windows
    SuperStitch("brokenImg\",10,100);
else%Linux/Mac
    SuperStitch("brokenImg/",10,100);
end
