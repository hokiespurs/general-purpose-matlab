function image8to16(I1name,I2name,I3name,docombine)
    if docombine
        I1 = imread(I1name);
        I1bits = dec2bin(I1);
        
        I2 = imread(I2name);
        I2bits = dec2bin(I2);
        
        I3bits = char(zeros(size(I1bits,1),16));
        I3bits(:,1:2:end) = I1bits;
        I3bits(:,2:2:end) = I2bits;
        
        I3 = reshape(uint16(bin2dec(I3bits)),size(I2));
        
        imwrite(I3,I3name);
    else
        I3 = imread(I3name);
        I3bits = dec2bin(I3);
        
        I1bits = I3bits(:,1:2:end);
        
        I2bits = I3bits(:,2:2:end);
        
        I1 = uint8(reshape(bin2dec(I1bits),size(I3)));
        I2 = uint8(reshape(bin2dec(I2bits),size(I3)));
        
        imwrite(I1,I1name);
        imwrite(I2,I2name);
    end

end

