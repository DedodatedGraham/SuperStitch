function [outImg] = MergeCong(inpImg,stitchdat,pxoff)
    % disp(string(mergepts))
    % disp(string(pxoff))
    %% Merge if decent offset
    pxoax = fix(pxoff(1,1));
    pxoay = fix(pxoff(1,2));
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
            if i >= 1 && j >= 1 && i <= ty && j <= tx && outImg(i,j) == 0
                outImg(i,j) = stitchdat.image(i - ay + 1,j - ax + 1);
            end
        end
    end
    stitchdat.added = true;
    % outputName = 'test.jpg';
    % s = append(pwd,'/output/testout/',outputName);
    % imwrite(outImg,s);
end

