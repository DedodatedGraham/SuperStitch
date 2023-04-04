function [newImg] = LocalStitch(data,i,j,N,M,lastImg)
%disp(append('current=[',string(i),',',string(j),']'));
%% direction and image setup
    strongcount = 20;
    %Here we intake our data and stitch together surounding data
    newImg = lastImg;
    %First if at starting pos, we add our current pic into the final image
    %before trying to add new ones
    if i == 1 && j == 1
        tx = data(i,j).x;
        ty = data(i,j).y;
        [th,tw,~] = size(data(i,j).image);
        newImg(ty:ty+th-1,tx:tx+tw-1,:) = data(i,j).image;
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
            [th,tw,~] = size(thisData.image);
            [ch,cw,~] = size(compData.image);
            strongt = thisData.surf.selectStrongest(strongcount);
            strongc = compData.surf.selectStrongest(strongcount);
            if iagg ~= 0
                if iagg == -1
                    %up
                    ou = thisData.y;
                    od = compData.y + ch;
                    %disp(append('current=[',string(i),',',string(j),'] reaching  x=',string(iagg)));
                    %disp(append('AbsLeftBound=',string(ol),' AbsRightBound=',string(orr)));
                else
                    %down
                    ou = compData.y;
                    od = thisData.y + th;
                    %disp(append('current=[',string(i),',',string(j),'] reaching  x=',string(iagg)));
                    %disp(append('AbsLeftBound=',string(ol),' AbsRightBound=',string(orr)));
                end
                %Next we line up the overlapping regions points
                tptlist = zeros(1,2);
                cptlist = zeros(1,2);
                added = 0;
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(2) + thisData.y > ou && st(2) + thisData.y < od
                        if added == 0
                            tptlist = strongt(cnt).Location;
                            added = added + 1;
                        else
                            tptlist = [tptlist;strongt(cnt).Location];
                        end
                    end
                end
                added = 0;
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(2) + compData.y > ou && ct(2) + compData.y < od
                        if added == 0
                            cptlist = strongc(cnt).Location;
                            added = added + 1;
                        else
                            cptlist = [cptlist;strongc(cnt).Location];
                        end
                    end
                end
                %Now we have all points which should be in the same area:)
                if i == 1 && j == 1
                    ou
                    od
                    iagg
                    tptlist
                    cptlist
                end
            elseif jagg ~= 0
                if jagg == -1
                    %left
                    ol = thisData.x;
                    or = compData.x + cw;
                else
                    %right
                    ol = compData.x;
                    or = thisData.x + tw;
                end
                %Next we line up the overlapping regions points
                tptlist = zeros(1,2);
                cptlist = zeros(1,2);
                added = 0;
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(1) + thisData.x > ol && st(1) + thisData.x < or
                        if added == 0
                            tptlist = strongt(cnt).Location;
                            added = added + 1;
                        else
                            tptlist = [tptlist;strongt(cnt).Location];
                        end
                    end
                end
                added = 0;
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(1) + compData.x > ol && ct(1) + compData.x < or
                        if added == 0
                            cptlist = strongc(cnt).Location;
                            added = added + 1;
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