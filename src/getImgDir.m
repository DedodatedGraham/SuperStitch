function [go,outData,iagg,jagg] = getImgDir(data,i,j,N,M,pos)
    %pos - n => [up,down,left,right]/[1,2,3,4]
    %Finds if we should stitch, and direcitonal data with that
    go = true;
    outData = 0;
    iagg = 0;
    jagg = 0;
    if pos == 1 && i ~= 1 
        %up
        if data(i - 1,j).added ~= true
            outData = data(i - 1,j);
        else
            go = false;
        end
        iagg = -1;
    elseif pos == 2 && i ~= M 
        %down
        if data(i + 1,j).added ~= true
            outData = data(i + 1,j);
        else
            go = false;
        end
        iagg = 1;
    elseif pos == 3 && j ~= 1 
        %left
        if data(i,j - 1).added ~= true
            outData = data(i,j - 1);
        else
            go = false;
        end
        jagg = -1;
    elseif pos == 4 && j ~= N 
        %right
        if data(i,j + 1).added ~= true
            outData = data(i,j + 1);
        else
            go = false;
        end
        jagg = 1;
    else
        go = false;
    end
end