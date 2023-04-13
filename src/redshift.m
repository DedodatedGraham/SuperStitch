function [besti,bestj] = redshift(thisData,compData,i,j,iagg,jagg,shiftmax)
    [th,tw,~] = size(thisData.image);
    [ch,cw,~] = size(compData.image);
    besti = 0;
    bestj = 0;

    if iagg ~= 0
        if iagg == 1
            tou = compData.y - thisData.y;
            tod = th;
            cou = 1;
            cod = tod-tou;
        else
            tou = 1;
            tod = ch - (thisData.y - compData.y);
            cou = ch - (tod - tou);
            cod = ch;
        end
        disp(append('iagg= ',string(iagg),' jagg= ',string(jagg)));
        disp(append(' tou= ',string(tou),' tod= ',string(tod),' cou= ',string(cou),' cod= ',string(cod)));
        disp(' ');                
    else
        if jagg == 1 
            tol = compData.x - thisData.x;
            tor = tw;
            col = 1;
            cor = tor-tol;
        else
            tol = 1;
            tor = cw - (thisData.x - compData.x);
            col = cw - (tor - tol);
            cor = cw;
        end
        disp(append('iagg= ',string(iagg),' jagg= ',string(jagg)));
        disp(append(' tol= ',string(tol),' tor= ',string(tor),' col= ',string(col),' cor= ',string(cor)));
        disp(' '); 
    end




%     for q=-shiftmax:1:shiftmax
%         for p=-shiftmax:1:shiftmax
%             %We go thorugh the shift, as we know compdata is relatively
%             %true; 
%         end
%     end
end



