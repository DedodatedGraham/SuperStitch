clear
clc
if ispc()%if Windows
    SuperStitch("brokenImg\",38,12);
else%Linux/Mac
    SuperStitch("brokenImg/",38,12);
end
