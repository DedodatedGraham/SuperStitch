function [outImg] = MergeCong(inpImg,stitchdat,graspdat,iagg,jagg,mergepts,pxoff)
    % disp(string(mergepts))
    % disp(string(pxoff))
    %% Merge if decent offset
    [long,~] = size(mergepts);
    pxoax = 0;
    pxoay = 0;
    for i=1:1:long
        %disp(string(i))
        pxoax = pxoax + pxoff(i,1);
        pxoay = pxoay + pxoff(i,2);
    end
    pxoax = fix(pxoax / long);
    pxoay = fix(pxoay / long);
    %We will try and match the points based on the average movement of
    %points we will apply the picture the picture at the offset, and fill
    %in missing pixels with information
    outImg = inpImg;
    %find relative x&y & h&w
    ax = stitchdat.x + pxoax;
    ay = stitchdat.y + pxoay;
    [sy,sx,~] = size(stitchdat.image);
    [ty,tx,~] = size(outImg);
    %go through each
    for i=ay:1:ay+sy-1
        for j=ax:1:ax+sx-1
            if i >= 1 && j >= 1 && i <= ty && j <= tx && outImg(i,j,1) == 0 && outImg(i,j,2) == 0 && outImg(i,j,3) == 0
                outImg(i,j,:) = stitchdat.image(i - ay + 1,j - ax + 1,:);
            end
        end
    end
    stitchdat.added = true;
end

