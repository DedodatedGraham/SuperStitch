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
                ot = 0;
                od = 0;
                ol = 0;
                orr = 0;
                if iagg == -1
                    %left
                    ol = thisData.x;
                    orr = compData.x + cw;
                else
                    %right
                    ol = compData.x;
                    orr = thisData.x + tw;
                end
                %Next we line up the overlapping regions points
                tptlist = zeros(1,2);
                cptlist = zeros(1,2);
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(1) > ol && st(1) < orr
                        if size(tptlist,1) == 1
                            tptlist = strongt(cnt).Location;
                        else
                            tptlist = [tptlist;strongt(cnt).Location];
                        end
                    end
                end
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(1) > ol && ct(1) < orr
                        if size(cptlist,1) == 1
                            cptlist = strongc(cnt).Location;
                        else
                            cptlist = [cptlist;strongc(cnt).Location];
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
                tptlist = zeros(1,2);
                cptlist = zeros(1,2);
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(2) > ot && st(2) < od
                        if size(tptlist,1) == 1
                            tptlist = strongt(cnt).Location;
                        else
                            tptlist = [tptlist;strongt(cnt).Location];
                        end
                    end
                end
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(2) > ot && ct(2) < od
                        if size(cptlist,1) == 1
                            cptlist = strongc(cnt).Location;
                        else
                            cptlist = [cptlist;strongc(cnt).Location];
                        end
                    end
                end
                %Now we have all points which should be in the same area:)
            end
        end
    end
end