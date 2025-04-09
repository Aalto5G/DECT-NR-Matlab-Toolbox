%
% decodes and scrambles PDC data bits 
%
% Inverse of Bit collection section and transmission
% 103636-3 
% 6.1.5.3
%

% Kalle Ruttik
% 10.8.2023

function [pdc_dec_data,err] = dectPDCDecode(pdc_soft_bits,NetworkID,N_PDC_re, phy_Control_Field,transmission_modes,mu_beta)

N_ss = transmission_modes.N_ss;
PhysicalLayerControlFieldType = phy_Control_Field.Type;
MCS = phy_Control_Field.DF_MCS;

[modulation,N_bps,R] = dectMCSTable(MCS);
N_PDC_subc = N_PDC_re;
G = N_ss*N_PDC_subc*N_bps;

% scrambling code
tmpID = dec2bin(NetworkID,32);
% % commented on 24.10.2024 by kru
% % if PhysicalLayerControlFieldType == 0
% % 
% %     g_init = 0x00000000;
% % 
% % else 
% %   if PhysicalLayerControlFieldType == 1
% %       rv = 0;
% %       % tmpID_24 = bin2dec(tmpID(9:end));
% %       % g_init = tmpID_24; %mod(bitshift(NetworkID,8),0x00ffffff);
% %       g_init = phy_Control_Field.short_Network_ID;
% %       % rv = phy_Control_Field.DF_Redundancy_Version;
% % 
% %   else 
% %     if PhysicalLayerControlFieldType == 2
% %       rv = phy_Control_Field.DF_Redundancy_Version;
% % %      tmpID_short = bin2dec(tmpID(25:end));
% % 
% % 
% % %      tmpID_24 = bin2dec(tmpID(9:end));
% %       g_init = tmpID_24; %mod(bitshift(NetworkID,8),0x00ffffff);
% % %      g_init = tmpID_short; % mod(NetworkID,0x000000ff);
% %     end
% %   end
% % end
%%
% scrambling
tmpID = dec2bin(NetworkID,32);
if PhysicalLayerControlFieldType == 0
g_init = 0x00000000;
else 
  if PhysicalLayerControlFieldType == 1
      rv = 0;
   tmp = de2bi(NetworkID,32);
   g_init = bi2de(tmp(1:8));
  else 
   if PhysicalLayerControlFieldType == 2
      rv = 0; 
   tmp = de2bi(NetworkID,32);
   g_init = bi2de(tmp(9:end));
   end
  end
end
%g_init = 0x00000001;
 [seq,g_init] = ltePRBS(g_init,G);

 d_descrambled = pdc_soft_bits.*(2*seq(1:length(pdc_soft_bits))-1);
 
 [ind_pdc]   = dectPDCind(phy_Control_Field,transmission_modes,mu_beta);
 N_PDC_re = length(ind_pdc);

 [N_TB_bits] = bitLenEval(N_PDC_re, N_ss, N_bps, R);
 % [N_TB_bits] = dectTransportBlockSize(N_PDC_re,phy_Control_Field,transmission_modes,mu_beta);

 pdc_coded_blk_rx = dect_RateRecoverTurbo(d_descrambled,N_TB_bits,rv,N_ss,N_bps);
% rrecovered = lteRateRecoverTurbo((d_descrambled),N_TB_bits,rv);
% size(rrecovered{1})
 
% sum(rrecovered{1}~= pdc_coded_blk{1})
 datarx_crc_seg = lteTurboDecode(pdc_coded_blk_rx);

%  datarx_crc = lteCodeBlockDesegment(decoder_out,N_TB_bits+24);
[datarx_crc,err] =LTE_CodeBlockDesegment(datarx_crc_seg,N_TB_bits+24);
crcPoly = '24A';
[pdc_dec_data,err] = lteCRCDecode(datarx_crc,crcPoly);
% err
%  %pdc_dec_data = decoder_out;
%  dec_bits = [];
%  if length(decoder_out)==1
%  [tmp_dec,err] = lteCRCDecode(decoder_out{1},'24A'); %7.5.2.1
%  dec_bits = tmp_dec;
%  else
%  for i1 = 1:length(decoder_out)
%    [tmp_dec,err] = lteCRCDecode(decoder_out{i1},'24B'); %7.5.2.1
%    if err==0
%     dec_bits = [dec_bits; tmp_dec];
%    else 
%      break
%    end
%  end
%  if err == 0
%  [tmp_dec,err] = lteCRCDecode(dec_bits,'24A'); %7.5.2.1
%  dec_bits = tmp_dec;
%  end
%  end
% 
%  if err ==0
%    pdc_dec_data = dec_bits;
%  else 
%    pdc_dec_data = [];
%  end 

end
