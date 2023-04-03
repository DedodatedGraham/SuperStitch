function [newImg] = LocalStitch(data,i,j,N,M,lastImg)
%% direction and image setup
    strongcount = 20;

    %Here we intake our data and stitch together surounding data
    newImg = lastImg;
    %First if at starting pos, we add our current pic into the final image
    %before trying to add new ones
    if i == 1 && j == 1
        tx = data(i,j).x;
        ty = data(i,j).y;
        [tw,th,~] = size(data(i,j).image);
        newImg(tx:tx+tw-1,ty:ty+th-1,:) = data(i,j).image;
        data(i,j).added = true;
    end
%% stitch each neighbor 
    %first we go to each direction, in order of reach %[up,down,right,left]
    thisData = data(i,j);
    for pos=1:4
        %Get our direcitonal stitching data
        [go,compData,iagg,jagg] = getImgDir(data,i,j,N,M,pos);
        if go %Note prevents tries for already stitched into the congolomerage images
            %Now that we have two data blocks, we want to calculate overlap
            %region and gather the surfpoints
            [tw,th,~] = size(thisData.image);
            [cw,ch,~] = size(compData.image);
            strongt = thisData.surf.selectStrongest(strongcount);
            strongc = compData.surf.selectStrongest(strongcount);
            if iagg ~= 0
                if iagg == -1
                    %left
                    ol = thisData.x;
                    or = compData.x + cw;
                else
                    %right
                    ol = compData.x;
                    or = thisData.x + tw;
                end
                %Next we line up the overlapping regions points
                tptlist = zeros(1);
                cptlist = zeros(1);
                for cnt=1:strongcount
                    stx = strongt(cnt).Location(0);
                    ctx = strongc(cnt).Location(0);
                    if stx > ol && stx < or
                        if size(tptlist) == 1
                            tptlist(1) = strongt(cnt);
                        else
                            tptlist = [tptlist,strongt(cnt)];
                        end
                    end
                    if ctx > ol && ctx < or
                        if size(cptlist) == 1
                            cptlist(1) = strongc(cnt);
                        else
                            cptlist = [cptlist,strongc(cnt)];
                        end
                    end
                end
                %Now we have all points which should be in the same area:)
            else
                if jagg == -1
                    %down
                    ot = compData.y;
                    od = thisData.y + th;
                else
                    %up
                    ot = thisData.y;
                    od = compData.y + ch;
                end
                %Next we line up the overlapping regions points
                tptlist = zeros(1);
                cptlist = zeros(1);
                for cnt=1:strongcount
                    sty = strongt(cnt).Location(1);
                    cty = strongc(cnt).Location(1);
                    if sty > ot && sty < od
                        if size(tptlist) == 1
                            tptlist(1) = strongt(cnt);
                        else
                            tptlist = [tptlist,strongt(cnt)];
                        end
                    end
                    if cty > ot && cty < od
                        if size(cptlist) == 1
                            cptlist(1) = strongc(cnt);
                        else
                            cptlist = [cptlist,strongc(cnt)];
                        end
                    end
                end
                %Now we have all points which should be in the same area:)
            end
        end
    end
end