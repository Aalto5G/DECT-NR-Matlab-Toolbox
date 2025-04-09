%
% recovers the blocks from rate matched stream
%

% Kalle Ruttik
% 30.10.2024

function [cbs] = dect_RateRecoverTurbo(rx,blklen,rv,N_ss,N_bps)

lenout = length(rx);
% segments
cStruct = dect_SegmentStruct(blklen);

% encoded blocks
% minLen = (cStruct.Kmin+4)*3
% maxlen = (cStruct.Kplus+4)*3
% punctured block sizes 
C = cStruct.C;
Cmin = cStruct.Cmin;
Cplus = cStruct.Cplus;
Kmin = cStruct.Kmin;
Kplus = cStruct.Kplus;
F = cStruct.F;
L = cStruct.L;
Bprim = cStruct.Bprim;

Gprim = lenout/(N_ss*N_bps);
gamma = mod(Gprim,C);

Emin = N_ss*N_bps*floor(Gprim/C);
Emax = N_ss*N_bps*ceil(Gprim/C);

% split the stream into blocks
locinpkt = 0;
for seginx = 1:C
  if seginx < gamma
    E = Emin;
  else 
    E = Emax;
  end
  tmpbits = rx(locinpkt + [1:E] );
  locinpkt = locinpkt + E;

  % Ch_deinterleave tmpbit
  if seginx <= Cmin
    K = Kmin;
  else 
    K = Kplus;
  end
  
  C_subblock_TC = 32;
  R_subblock_TC = ceil((K+4)/C_subblock_TC);
  K1 = C_subblock_TC*R_subblock_TC;
  K1_3 = 3*K1;

  codedK = (K+4)*3;  
  % put bits into derate matched vector
  tmp0 = zeros(1,codedK);
  if seginx == 1
    tmp0(1:F) = -1;
    tmp0((K+4) +[1:F]) = -1;
  end

  [o] = LTE_ChannelInterleaver(tmp0);
  w = zeros(1,length(o));

  N_cb = K1_3;
  k0 = R_subblock_TC*(2*ceil(N_cb/(8*R_subblock_TC))*rv+2);
  
  k = 0;
  j = 0;
  while k < E
    if(o(mod((k0+j),K1_3)+1)~=-1)
      w(mod((k0+j),K1_3)+1) = w(mod((k0+j),K1_3)+1) + tmpbits(k+1);
      k = k+1;
    end
   j = j+1;
  end



  tmpdeinterl = LTE_ChannelDeinterleaver(w,K);
  cbs{seginx} = tmpdeinterl;

end
% demap to the encoded blocks 

end
