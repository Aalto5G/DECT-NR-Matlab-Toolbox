function msg = binMsg2unit8Converter(bin, lengthInBytes)
    msg = zeros(1,lengthInBytes);
    for i = 1:lengthInBytes
        msg(i) = uint8(bi2de(fliplr(bin(1+(i-1)*8 : 8+(i-1)*8))));
    end
end