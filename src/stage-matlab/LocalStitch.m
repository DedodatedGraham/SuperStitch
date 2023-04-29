function [newImg,newData,newAdd] = LocalStitch(data,i,j,N,M,lastImg,lastAdd)
%% direction and image setup
    % disp(append('AT: [',string(i),'/',string(M),'],[',string(j),'/',string(N),']'))
    strongcount = 100;
    maxoffset = 10;%pixel max offset count
    %Here we intake our data and stitch together surounding data
    newImg = lastImg;
    newAdd = lastAdd;
    %First if at starting pos, we add our current pic into the final image
    %before trying to add new ones
    if i == 1 && j == 1 && data(i,j).added == false
        tx = data(i,j).x;
        ty = data(i,j).y;
        [th,tw,~] = size(data(i,j).image);
        newImg(ty:ty+th-1,tx:tx+tw-1,:) = data(i,j).image;
        newAdd(ty:ty+th-1,tx:tx+tw-1) = true;
        data(i,j).added = true;
    end
%% stitch each neighbor 
    %first we go to each direction, in order of reach %[up,down,left,right]
    thisData = data(i,j);
    for pos=1:4
        %Get our direcitonal stitching data
        [go,compData,iagg,jagg] = getImgDir(data,i,j,N,M,pos);
        % if i < 10 && j < 10
        %     disp(append('at ',string(i),',',string(j)));
        %     disp(append('Looking:(',string(iagg),',',string(jagg),')',string(go)));
        % end
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
                else
                    %down
                    ou = compData.y;
                    od = thisData.y + th;
                end
                %Next we line up the overlapping regions points
                tptlist = SURFPoints;
                cptlist = SURFPoints;
                addedt = 1;
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(2) + thisData.y > ou - maxoffset && st(2) + thisData.y < od + maxoffset
                        % tptlist(addedt,1) = st(1) + thisData.x;
                        % tptlist(addedt,2) = st(2) + thisData.y;
                        tptlist(addedt) = strongt(cnt);
                        addedt = addedt + 1;
                    end
                end
                addedc = 1;
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(2) + compData.y > ou - maxoffset && ct(2) + compData.y < od + maxoffset
                        % cptlist(addedc,1) = ct(1) + compData.x;
                        % cptlist(addedc,2) = ct(2) + compData.y;
                        cptlist(addedc) = strongc(cnt);
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
                tptlist = SURFPoints;
                cptlist = SURFPoints;
                addedt = 1;
                for cnt=1:strongt.Count
                    st = strongt(cnt).Location;
                    if st(1) + thisData.x > ol - maxoffset && st(1) + thisData.x < orr + maxoffset
                        % tptlist(addedt,1) = st(1) + thisData.x;
                        % tptlist(addedt,2) = st(2) + thisData.y;
                        tptlist(addedt) = strongt(cnt);
                        addedt = addedt + 1;
                    end
                end
                addedc = 1;
                for cnt=1:strongc.Count
                    ct = strongc(cnt).Location;
                    if ct(1) + compData.x > ol - maxoffset && ct(1) + compData.x < orr + maxoffset
                        % cptlist(addedc,1) = ct(1) + compData.x;
                        % cptlist(addedc,2) = ct(2) + compData.y;
                        cptlist(addedc) = strongc(cnt);
                        addedc = addedc + 1;
                    end
                end
            end
            %Now we have all points which should be in the overlap area for each this and comp list:)
            % [tcount,~] = size(tptlist);
            % [ccount,~] = size(cptlist);
            added = 0;
            % disp(append('addedc=',string(addedc),' addedt=',string(addedc)));
            % disp(append('compbounds = [',string(compData.x),',',string(compData.y),'] [',string(compData.x+cw),',',string(compData.y+ch),']'))
            % disp(append('thisbounds = [',string(thisData.x),',',string(thisData.y),'] [',string(thisData.x+tw),',',string(thisData.y+th),']'))
            % for ti=1:strongc.length
            %     disp(append('strongc = ',string(strongc.Location(ti,1) + compData.x),' , ',string(strongc.Location(ti,2)) + compData.y));
            % end
            % disp(' ')
            % for ti=1:strongt.length
            %     disp(append('strongt = ',string(strongt.Location(ti,1) + thisData.x),' , ',string(strongt.Location(ti,2)) + thisData.y));
            % end
            if addedc > 1 && addedt > 1
                %first calculate sum offset up to this point,
                % sxoff = 0;
                % syoff = 0;
                % if i ~= 1 
                %     for newi=i-1:-1:1
                %         syoff = syoff + data(newi,j).offy;
                %     end
                % end
                % if j ~= 1 
                %     for newj=j-1:-1:1
                %         sxoff = sxoff + data(i,newj).offx;
                %     end
                % end
                % disp(append('sum-offset =>',string(syoff),',',string(sxoff))
                % disp(' ');
                [cfeat,cptlist] = extractFeatures(data(i+iagg,j+jagg).image,cptlist);
                [tfeat,tptlist] = extractFeatures(data(i,j).image,tptlist);
                indexpairs = matchFeatures(cfeat,tfeat,'Unique',true);
                pxoffset = zeros(1,2);
                pxnx = 0;
                pxny = 0;
                [lindpair,~] = size(indexpairs);
                for newi=1:lindpair
                    %we go through each pair and calculate the offset
                    %disp(append('Comp = [',string(compData.x + cptlist.Location(indexpairs(newi,1),1)),',',string(compData.y + cptlist.Location(indexpairs(newi,1),2)),']'))
                    %disp(append('Comp = [',string(thisData.x + tptlist.Location(indexpairs(newi,2),1)),',',string(thisData.y + tptlist.Location(indexpairs(newi,2),2)),']'))
                    if (compData.x + cptlist.Location(indexpairs(newi,1),1)) ~= (thisData.x + tptlist.Location(indexpairs(newi,2),1))
                        dx = (thisData.x + tptlist.Location(indexpairs(newi,2),1)) - (compData.x + cptlist.Location(indexpairs(newi,1),1));
                        pxoffset(1,1) = pxoffset(1,1) + dx;
                        pxnx = pxnx + 1;
                    end
                    if (compData.y + cptlist.Location(indexpairs(newi,1),2)) ~= (thisData.y + tptlist.Location(indexpairs(newi,2),2))
                        dy =  (thisData.y + tptlist.Location(indexpairs(newi,2),2)) - (compData.y + cptlist.Location(indexpairs(newi,1),2));
                        pxoffset(1,2) = pxoffset(1,2) + dy;
                        pxny = pxny + 1;
                    end
                end
                if pxnx ~= 0
                    pxoffset(1,1) = pxoffset(1,1) / pxnx;
                else
                    pxoffset(1,1) = 0;
                end
                if pxny ~=0
                    pxoffset(1,2) = pxoffset(1,2) / pxny;
                else
                    pxoffset(1,2) = 0;
                end
                added = max(pxnx,pxny);
                % disp(append(string(pxoffset(1,1)),',',string(pxoffset(1,2))))
                % for newi=1:1:addedt - 1
                %     for newj=1:1:addedc - 1
                %         if abs(tptlist(newi,1)-cptlist(newj,1)) < maxoffset && abs(tptlist(newi,2)-cptlist(newj,2)) < maxoffset
                %             if ~this.added
                %                 ptlist(added,1) = cptlist(newj,1);
                %                 ptlist(added,2) = cptlist(newj,2);
                %                 pxoffset(added,1) = cptlist(newj,1) - tptlist(newi,1) ;
                %                 pxoffset(added,2) = cptlist(newj,2) - tptlist(newi,2) ;
                %             else
                %                 ptlist(added,1) = tptlist(newi,1);
                %                 ptlist(added,2) = tptlist(newi,2);
                %                 pxoffset(added,1) = tptlist(newi,1) - cptlist(newj,1) ;
                %                 pxoffset(added,2) = tptlist(newi,2) - cptlist(newj,2) ;
                %             end
                %             added = added + 1;
                %             %break;
                %         end
                %     end
                % end
                % ptlist = ptlist(1:added-1,:);
                % pxoffset = pxoffset(1:added-1,:);
                if thisData.added ~= true && added > 0
                    % disp('Merging this');
                    newImg = MergeCong(newImg,thisData,pxoffset);
                    data(i,j).added = true;
                    for runi=i+1:M
                        if ~data(runi,j).added
                            for runj=j+1:N
                                data(runi,runj).y = data(runi,j).y + fix(pxoffset(1,2));
                            end
                        end
                    end
                    for runj=j+1:N
                        if ~data(i,runj).added
                            for runi = i+1:M
                                data(runi,runj).x = data(i,runj).x + fix(pxoffset(1,1));
                            end
                        end
                    end
                    thisData.added = true;
                    %After stitching, we will adjust all pictures int the
                    %+x&y
                    % data(i,j).offx = fix(pxoax / (added - 1));
                    % data(i,j).offy = fix(pxoay / (added - 1));
                    % if iagg ~= 0
                    %     if iagg == 1
                    %         %down
                    %         ys = thisData.y;
                    %         ye = compData.y;
                    %         thisapp = thisData.image(1:ye-ys,:,:);
                    %         newImg(ys:ye-1,thisData.x:thisData.x+tw - 1,:) = thisapp; 
                    %     else
                    %         %up
                    %         ys = compData.y + ch;
                    %         ye = thisData.y + th;
                    %         thisapp = thisData.image(compData.y + ch - thisData.y:th - 1,:,:);
                    %         newImg(ys:ye-1,thisData.x:thisData.x+tw - 1,:) = thisapp; 
                    %     end
                    % else
                    %     if jagg == 1
                    %         %right
                    %         xs = thisData.x;
                    %         xe = compData.x;
                    %         thisapp = thisData.image(:,1:xe-xs,:);
                    %         newImg(thisData.y:thisData.y+th-1,xs:xe-1,:) = thisapp; 
                    %     else
                    %         %left
                    %         xs = compData.x + cw;
                    %         xe = thisData.x + tw;
                    %         thisapp = thisData.image(:,compData.x + cw - thisData.x:tw - 1,:);
                    %         newImg(thisData.y:thisData.y+th-1,xs:xe-1,:) = thisapp; 
                    %     end
                    % end
                    % data(i,j).added = true;
                    % thisData.added = true;
                end
                %if we are stitching our comp data
                if compData.added ~= true && added > 1
                    % disp('Merging comp');
                    newImg = MergeCong(newImg,compData,pxoffset);
                    data(i+iagg,j+jagg).added = true;
                    for runi=i+1:M
                        if ~data(runi,j).added
                            for runj=j+1:N
                                data(runi,runj).y = data(runi,j).y + fix(pxoffset(1,2));
                            end
                        end
                    end
                    for runj=j+1:N
                        if ~data(i,runj).added
                            for runi=i+1:M
                                data(runi,runj).x = data(i,runj).x + fix(pxoffset(1,1));
                            end
                        end
                    end
                    compData.added = true;
                    % data(i+iagg,j+jagg).offx = fix(pxoax / (added - 1));
                    % data(i+iagg,j+jagg).offy = fix(pxoay / (added - 1));
                    % if iagg ~= 0
                    %     if iagg == 1
                    %         %down
                    %         ys = thisData.y + th;
                    %         ye = compData.y + ch;
                    %         compapp = compData.image(thisData.y + th - compData.y:ch-1,:,:);
                    %         newImg(ys:ye-1,compData.x:compData.x+cw-1,:) = compapp; 
                    %     else
                    %         %up
                    %         ys = compData.y;
                    %         ye = thisData.y;
                    %         compapp = compData.image(1:ye-ys,:,:); 
                    %         newImg(ys:ye-1,compData.x:compData.x+cw-1,:) = compapp;
                    %     end
                    % else
                    %     if jagg == 1
                    %         %right
                    %         xs = thisData.x + tw;
                    %         xe = compData.x + cw;
                    %         compapp = compData.image(:,thisData.x + tw - compData.x:cw-1,:);
                    %         newImg(compData.y:compData.y+ch-1,xs:xe-1,:) = compapp;
                    %     else
                    %         %left
                    %         xs = compData.x;
                    %         xe = thisData.x;
                    %         compapp = compData.image(:,1:xe-xs,:);
                    %         newImg(compData.y:compData.y+ch-1,xs:xe-1,:) = compapp;
                    %     end
                    % end
                    % data(i+iagg,j+jagg).added = true;
                    % compData.added = true;
                end
                % disp(string(data(i,j).added));
                % disp(string(data(i+iagg,j+jagg).added));
                
            end
            % disp(' ');
        end
    end
    newData = data;
end