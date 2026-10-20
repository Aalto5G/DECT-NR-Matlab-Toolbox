%
% estimate soft symbols from the received IQ samples 
%

% Kalle Ruttik
% 11.8.2023

function [soft_symbols] = dectSymbolDeMapping(pcc_re_symbols,MCS)

switch MCS

  case 0
    %soft_symbols = real(pcc_re_symbols*(exp(-1i*pi/4)));
    soft_symbols = real(pcc_re_symbols);

  case {1,2}
    soft_symbols = zeros(length(pcc_re_symbols)*2,1);
    soft_symbols(1:2:end) = real(pcc_re_symbols); % *(exp(-1i*pi/4));
    soft_symbols(2:2:end) = imag(pcc_re_symbols); % *(exp(-1i*pi/4));
%    soft_symbols(1:2:end) = real(pcc_re_symbols*(exp(-1i*pi/4)));
%    soft_symbols(2:2:end) = imag(pcc_re_symbols*(exp(-1i*pi/4)));
  
  case {3,4} 
    % 16 QAM
    len = length(pcc_re_symbols);
    soft_symbols = zeros(length(pcc_re_symbols)*4,1);
    const_pts = [-3 -1 1 3]/sqrt(10);
    const_pts2 = const_pts.*const_pts;
    tmpbits0 = zeros(1,len*4);
    tmpbits1 = zeros(1,len*4);
    tmp_real = real(pcc_re_symbols);
    tmp_imag = imag(pcc_re_symbols);
    
    tmpbits0(1:4:end) = boxplus((2*tmp_real*const_pts(3) - const_pts2(3)),(2*tmp_real*const_pts(4) - const_pts2(4)));  
    tmpbits1(1:4:end) = boxplus((2*tmp_real*const_pts(1) - const_pts2(1)),(2*tmp_real*const_pts(2) - const_pts2(2)));  
    tmpbits0(3:4:end) = boxplus((2*tmp_real*const_pts(2) - const_pts2(2)),(2*tmp_real*const_pts(3) - const_pts2(3)));  
    tmpbits1(3:4:end) = boxplus((2*tmp_real*const_pts(1) - const_pts2(1)),(2*tmp_real*const_pts(4) - const_pts2(4)));  
    tmpbits0(2:4:end) = boxplus((2*tmp_imag*const_pts(3) - const_pts2(3)),(2*tmp_imag*const_pts(4) - const_pts2(4)));  
    tmpbits1(2:4:end) = boxplus((2*tmp_imag*const_pts(1) - const_pts2(1)),(2*tmp_imag*const_pts(2) - const_pts2(2)));  
    tmpbits0(4:4:end) = boxplus((2*tmp_imag*const_pts(2) - const_pts2(2)),(2*tmp_imag*const_pts(3) - const_pts2(3)));  
    tmpbits1(4:4:end) = boxplus((2*tmp_imag*const_pts(1) - const_pts2(1)),(2*tmp_imag*const_pts(4) - const_pts2(4)));  
    % tmpbits0(1:4:end) = (tmp_real-const_pts(3)).^2+(tmp_real-const_pts(4)).^2;
    % tmpbits1(1:4:end) = (tmp_real-const_pts(1)).^2+(tmp_real-const_pts(2)).^2;
    % tmpbits0(3:4:end) = (tmp_real-const_pts(2)).^2+(tmp_real-const_pts(3)).^2;
    % tmpbits1(3:4:end) = (tmp_real-const_pts(1)).^2+(tmp_real-const_pts(4)).^2;
    % tmpbits0(2:4:end) = (tmp_imag-const_pts(3)).^2+(tmp_imag-const_pts(4)).^2;
    % tmpbits1(2:4:end) = (tmp_imag-const_pts(1)).^2+(tmp_imag-const_pts(2)).^2;
    % tmpbits0(4:4:end) = (tmp_imag-const_pts(2)).^2+(tmp_imag-const_pts(3)).^2;
    % tmpbits1(4:4:end) = (tmp_imag-const_pts(1)).^2+(tmp_imag-const_pts(4)).^2;
    
    soft_symbols = (tmpbits0-tmpbits1)';
  case {5,6,7}
    % 64 QAM
    % Mapping on one axis
    % 000 -> 3
    % 001 -> 1
    % 010 -> 5
    % 011 -> 7
    % 100 -> -3
    % 101 -> -1
    % 110 -> 5
    % 111 -> 7
    len = length(pcc_re_symbols);
    soft_symbols = zeros(length(pcc_re_symbols)*6,1);
    const_pts = [-7 -5 -3 -1 1 3 5 7]/sqrt(42);
    const_pts2 = const_pts.*const_pts;
    tmpbits0 = zeros(1,len*6);
    tmpbits1 = zeros(1,len*6);
    tmp_real = real(pcc_re_symbols);
    tmp_imag = imag(pcc_re_symbols);

    tmpbits0(1:6:end) = boxplus(boxplus(boxplus((2*tmp_real*const_pts(5) - const_pts2(5)),(2*tmp_real*const_pts(6) - const_pts2(6))),(2*tmp_real*const_pts(7)-const_pts2(7))),(2*tmp_real*const_pts(8)-const_pts2(8)));  
    tmpbits1(1:6:end) = boxplus(boxplus(boxplus((2*tmp_real*const_pts(1) - const_pts2(1)),(2*tmp_real*const_pts(2) - const_pts2(2))),(2*tmp_real*const_pts(3)-const_pts2(3))),(2*tmp_real*const_pts(4)-const_pts2(4)));  
    tmpbits0(3:6:end) = boxplus(boxplus(boxplus((2*tmp_real*const_pts(3) - const_pts2(3)),(2*tmp_real*const_pts(4) - const_pts2(4))),(2*tmp_real*const_pts(5)-const_pts2(5))),(2*tmp_real*const_pts(6)-const_pts2(6)));  
    tmpbits1(3:6:end) = boxplus(boxplus(boxplus((2*tmp_real*const_pts(1) - const_pts2(1)),(2*tmp_real*const_pts(2) - const_pts2(2))),(2*tmp_real*const_pts(7)-const_pts2(7))),(2*tmp_real*const_pts(8)-const_pts2(8)));  
    tmpbits0(5:6:end) = boxplus(boxplus(boxplus((2*tmp_real*const_pts(2) - const_pts2(2)),(2*tmp_real*const_pts(3) - const_pts2(3))),(2*tmp_real*const_pts(6)-const_pts2(6))),(2*tmp_real*const_pts(7)-const_pts2(7)));  
    tmpbits1(5:6:end) = boxplus(boxplus(boxplus((2*tmp_real*const_pts(1) - const_pts2(1)),(2*tmp_real*const_pts(4) - const_pts2(4))),(2*tmp_real*const_pts(5)-const_pts2(5))),(2*tmp_real*const_pts(8)-const_pts2(8)));  

    tmpbits0(2:6:end) = boxplus(boxplus(boxplus((2*tmp_imag*const_pts(5) - const_pts2(5)),(2*tmp_imag*const_pts(6) - const_pts2(6))),(2*tmp_imag*const_pts(7)-const_pts2(7))),(2*tmp_imag*const_pts(8)-const_pts2(8)));  
    tmpbits1(2:6:end) = boxplus(boxplus(boxplus((2*tmp_imag*const_pts(1) - const_pts2(1)),(2*tmp_imag*const_pts(2) - const_pts2(2))),(2*tmp_imag*const_pts(3)-const_pts2(3))),(2*tmp_imag*const_pts(4)-const_pts2(4)));  
    tmpbits0(4:6:end) = boxplus(boxplus(boxplus((2*tmp_imag*const_pts(3) - const_pts2(3)),(2*tmp_imag*const_pts(4) - const_pts2(4))),(2*tmp_imag*const_pts(5)-const_pts2(5))),(2*tmp_imag*const_pts(6)-const_pts2(6)));  
    tmpbits1(4:6:end) = boxplus(boxplus(boxplus((2*tmp_imag*const_pts(1) - const_pts2(1)),(2*tmp_imag*const_pts(2) - const_pts2(2))),(2*tmp_imag*const_pts(7)-const_pts2(7))),(2*tmp_imag*const_pts(8)-const_pts2(8)));  
    tmpbits0(6:6:end) = boxplus(boxplus(boxplus((2*tmp_imag*const_pts(2) - const_pts2(2)),(2*tmp_imag*const_pts(3) - const_pts2(3))),(2*tmp_imag*const_pts(6)-const_pts2(6))),(2*tmp_imag*const_pts(7)-const_pts2(7)));  
    tmpbits1(6:6:end) = boxplus(boxplus(boxplus((2*tmp_imag*const_pts(1) - const_pts2(1)),(2*tmp_imag*const_pts(4) - const_pts2(4))),(2*tmp_imag*const_pts(5)-const_pts2(5))),(2*tmp_imag*const_pts(8)-const_pts2(8)));  

    soft_symbols = (tmpbits0-tmpbits1)';
    printf('Not supported yet\n')    
  case {8,9,10,11}
    soft_symbols = [];
    printf('Not supported yet\n')
  otherwise
    soft_symbols = [];

end 
end


function o = boxplus(a,b)
  o = max(a,b)+log(1+exp(-abs(a-b)));
end