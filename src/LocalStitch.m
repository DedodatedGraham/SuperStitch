function [newImg,newData] = LocalStitch(data,i,j,N,M,lastImg)
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
    %first we go to each direction, in order of reach %[up,down,left,right]
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
                tptlist = zeros(strongcount,2);
                cptlist = zeros(strongcount,2);
                addedt = 1;
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(2) + thisData.y > ou && st(2) + thisData.y < od
                        tptlist(addedt,1) = st(1) + thisData.x;
                        tptlist(addedt,2) = st(2) + thisData.y;
                        addedt = addedt + 1;
                    end
                end
                addedc = 1;
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(2) + compData.y > ou && ct(2) + compData.y < od
                        cptlist(addedc,1) = ct(1) + compData.x;
                        cptlist(addedc,2) = ct(2) + compData.y;
                        addedc = addedc + 1;
                    end
                end
            elseif jagg ~= 0
                if jagg == -1
                    %left
                    ol = thisData.x;
                    orr = compData.x + cw;
                else
                    %right
                    ol = compData.x;
                    orr = thisData.x + tw;
                end
                %Next we line up the overlapping regions points
                tptlist = zeros(strongcount,2);
                cptlist = zeros(strongcount,2);
                addedt = 1;
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(1) + thisData.x > ol && st(1) + thisData.x < orr
                        tptlist(addedt,1) = st(1) + thisData.x;
                        tptlist(addedt,2) = st(2) + thisData.y;
                        addedt = addedt + 1;
                    end
                end
                addedc = 1;
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(1) + compData.x > ol && ct(1) + compData.x < orr
                        cptlist(addedc,1) = ct(1) + compData.x;
                        cptlist(addedc,2) = ct(2) + compData.y;
                        addedc = addedc + 1;
                    end
                end
            end
            %Now we have all points which should be in the overlap area for each this and comp list:)
            [tcount,~] = size(tptlist);
            [ccount,~] = size(cptlist);
            added = 1;
            if addedc > 1 && addedt > 1
                ptlist = zeros(strongcount,2);
                for newi=1:1:tcount
                    for newj=1:1:ccount
                        if tptlist(newi,:) == cptlist(newj,:)
                            ptlist(added,1) = tptlist(newi,1);
                            ptlist(added,2) = tptlist(newi,2);
                            added = added + 1;
                        end
                    end
                end
                %Now we stitch if there is a match of points
                %If we are stitching our current data
                if thisData.added ~= true
                    if iagg ~= 0
                        if iagg == 1
                            %down
                            ys = thisData.y;
                            ye = compData.y;
                            thisapp = thisData.image(1:ye-ys,:,:);
                            newImg(ys:ye-1,thisData.x:thisData.x+tw - 1,:) = thisapp; 
                        else
                            %up
                            ys = compData.y + ch;
                            ye = thisData.y + th;
                            thisapp = thisData.image(compData.y + ch - thisData.y:th - 1,:,:);
                            newImg(ys:ye-1,thisData.x:thisData.x+tw - 1,:) = thisapp; 
                        end
                    else
                        if jagg == 1
                            %right
                            xs = thisData.x;
                            xe = compData.x;
                            thisapp = thisData.image(:,1:xe-xs,:);
                            newImg(thisData.y:thisData.y+th-1,xs:xe-1,:) = thisapp; 
                        else
                            %left
                            xs = compData.x + cw;
                            xe = thisData.x + tw;
                            thisapp = thisData.image(:,compData.x + cw - thisData.x:tw - 1,:);
                            newImg(thisData.y:thisData.y+th-1,xs:xe-1,:) = thisapp; 
                        end
                    end
                    data(i,j).added = true;
                    thisData.added = true;
                end
                %if we are stitching our comp data
                if compData.added ~= true
                    if iagg ~= 0
                        if iagg == 1
                            %down
                            ys = thisData.y + th;
                            ye = compData.y + ch;
                            compapp = compData.image(thisData.y + th - compData.y:ch-1,:,:);
                            newImg(ys:ye-1,compData.x:compData.x+cw-1,:) = compapp; 
                        else
                            %up
                            ys = compData.y;
                            ye = thisData.y;
                            compapp = compData.image(1:ye-ys,:,:); 
                            newImg(ys:ye-1,compData.x:compData.x+cw-1,:) = compapp;
                        end
                    else
                        if jagg == 1
                            %right
                            xs = thisData.x + tw;
                            xe = compData.x + cw;
                            compapp = compData.image(:,thisData.x + tw - compData.x:cw-1,:);
                            newImg(compData.y:compData.y+ch-1,xs:xe-1,:) = compapp;
                        else
                            %left
                            xs = compData.x;
                            xe = thisData.x;
                            compapp = compData.image(:,1:xe-xs,:);
                            newImg(compData.y:compData.y+ch-1,xs:xe-1,:) = compapp;
                        end
                    end
                    data(i+iagg,j+jagg).added = true;
                    compData.added = true;
                end
            end
        end
    end
    newData = data;
end