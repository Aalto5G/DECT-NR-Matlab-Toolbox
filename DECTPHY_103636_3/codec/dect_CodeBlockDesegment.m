

function [blkacc,errblk] = dect_CodeBlockDesegment(cbs_rx,lenOut)


if ~iscell(cbs_rx)
  cbs_rxl{1} =cbs_rx;
else
  cbs_rxl = cbs_rx;
end
C = length(cbs_rxl);

errblk = 0;
blkacc = [];
for seginx = 1:C
  [blk,err] = dect_crc_dec_24B(cbs_rxl{seginx});
  if err == 1
    errblk = 1;
  end 
  blkacc = [blkacc;blk];
end
 
if rem(nargin,2) == 0
  blkacc = blkacc((end-lenOut+1):end);
end 

end