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
                addedt = 0;
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(2) + thisData.y > ou && st(2) + thisData.y < od
                        if addedt == 0
                            tptlist = [st(1) + thisData.x,st(2) + thisData.y];
                            addedt = addedt + 1;
                        else
                            tptlist = [tptlist;st(1) + thisData.x,st(2) + thisData.y];
                        end
                    end
                end
                addedc = 0;
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(2) + compData.y > ou && ct(2) + compData.y < od
                        if addedc == 0
                            cptlist = [ct(1) + compData.x,ct(2) + compData.y];
                            addedc = addedc + 1;
                        else
                            cptlist = [cptlist;ct(1) + compData.x,ct(2) + compData.y];
                        end
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
                tptlist = zeros(1,2);
                cptlist = zeros(1,2);
                addedt = 0;
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(1) + thisData.x > ol && st(1) + thisData.x < orr
                        if addedt == 0
                            tptlist = [st(1) + thisData.x,st(2) + thisData.y];
                            addedt = addedt + 1;
                        else
                            tptlist = [tptlist;st(1) + thisData.x,st(2) + thisData.y];
                        end
                    end
                end
                addedc = 0;
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(1) + compData.x > ol && ct(1) + compData.x < orr
                        if addedc == 0
                            cptlist = [ct(1) + compData.x,ct(2) + compData.y];
                            addedc = addedc + 1;
                        else
                            cptlist = [cptlist;ct(1) + compData.x,ct(2) + compData.y];
                        end
                    end
                end
            end
            %Now we have all points which should be in the overlap area for each this and comp list:)
            [tcount,~] = size(tptlist);
            [ccount,~] = size(cptlist);
            added = 0;
            if addedc > 0 && addedt > 0
                ptlist = zeros(1,2);
                for newi=1:1:tcount
                    for newj=1:1:ccount
                        if tptlist(newi,:) == cptlist(newj,:)
                            if added == 0
                                ptlist = tptlist(newi,:);
                                added = added + 1;
                            else
                                ptlist = [ptlist;tptlist(newi,:)];
                                added = added + 1;
                            end
                        end
                    end
                end
                %Now we stitch if there is a match of points
                if ~compData.added
                    if iagg ~= 0
                        %disp('iagg');
                        if iagg == 1
                            ys = thisData.y + th;
                            ye = compData.y + ch;
                        else
                            ys = compData.y;
                            ye = thisData.y;
                        end
                        newImg(ys:ye-1,compData.x:compData.x+cw-1,:) = compData.image(1:ye-ys,:,:); 
                    else
                        %disp('jagg');
                        if jagg == 1
                            xs = thisData.x + tw;
                            xe = compData.x + cw;
                        else
                            xs = compData.x;
                            xe = thisData.x;
                        end
                        newImg(compData.y:compData.y+ch-1,xs:xe-1,:) = compData.image(:,1:xe-xs,:); 
                    end
                    data(j+jagg,i+iagg).added = true;
                end
                % if false && ptlist(1,1) ~= 0 
                %     disp(' ');
                %     disp(append('[',string(i),',',string(j),']'));
                %     disp(append('[',string(iagg),',',string(jagg),']'));
                %     disp(append('this [',string(thisData.x),',',string(thisData.y),'] [',string(thisData.x + tw),',',string(thisData.y+th),']'));
                %     disp(append('comp [',string(compData.x),',',string(compData.y),'] [',string(compData.x + cw),',',string(compData.y+ch),']'));
                %     if iagg ~= 0
                %         disp(append('Overlapping Region [',string(thisData.x),',',string(ou),'] [',string(thisData.x + tw),',',string(od),']'));
                %     else
                %         disp(append('Overlapping Region [',string(ol),',',string(thisData.y),'] [',string(orr),',',string(thisData.y + th),']'));
                %     end
                %     for qcnt=1:added
                %         disp(append(string(qcnt),' point is [',string(ptlist(qcnt,1)),',',string(ptlist(qcnt,2)),']'));
                %     end
                %     disp(' ');
                % end
            % else
            %     disp(' ');
            %     disp(append('[',string(i),',',string(j),']'));
            %     disp(append('[',string(iagg),',',string(jagg),']'));
            %     disp(append('this [',string(thisData.x),',',string(thisData.y),'] [',string(thisData.x + tw),',',string(thisData.y+th),']'));
            %     disp(append('comp [',string(compData.x),',',string(compData.y),'] [',string(compData.x + cw),',',string(compData.y+ch),']'));
            %     disp('error no points to stitch :(((');
            %     disp(' ');
            end
        end
    end
end