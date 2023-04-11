function [besti,bestj] = redshift(thisData,compData,i,j,iagg,jagg,shiftmax)
    [th,tw,~] = size(thisData.image);
    [ch,cw,~] = size(compData.image);
    besti = 0;
    bestj = 0;
    for q=-shiftmax:1:shiftmax
        for p=-shiftmax:1:shiftmax
            %We go thorugh the shift, as we know compdata is relatively
            %true; 
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

                else

                end
            end
        end
    end
end



