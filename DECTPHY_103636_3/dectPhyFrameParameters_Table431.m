%
% Returns table values for spectrum scaling mu and Fourier scaling beta
% As defined in  
% 103636-3 1.4.1 Table 4.3-1

% Kalle Ruttik
% 3.8.2023

function [mu_beta] = DECTPhyFrameParameters_Table431(mu_inx,beta_inx)

%% set up the predefined tabulated values
% 103636-3 1.4.1 Table 4.3-1
mu_list = [1 2 4 8]; % transmission numerology
mu_Carrier_Spacing = [27 54 108 216]*1e3; % OFDM subcarriers spacing
N_SLOTmu_symb_list = [10 20 40 80];
N_SLOTmu_subslot_list = [2 4 8 16]; 

beta_list = [1 2 4 8 12 16]; % fourier transform scaling factor
N_DFT_list = [64 128 256 512 768 1024]; 
N_cp_list = [8 16 32 64 96 128]; 
N_occ_list = [56 112 224 448 672 896];

%% resource mapping

%% compute the frame parameters
% mu selected parameters
mu_beta.mu = mu_list(mu_inx);
mu_beta.Delta_mu_f = mu_Carrier_Spacing(mu_inx);
mu_beta.T_mu_symb = 1/(64*mu_beta.Delta_mu_f)*(N_DFT_list(mu_inx)+N_cp_list(mu_inx));
mu_beta.N_SLOTmu_symb = N_SLOTmu_symb_list(mu_inx);
mu_beta.N_SLOTmu_subslot = N_SLOTmu_subslot_list(mu_inx);

% mu and beta selected parameters
mu_beta.beta = beta_list(beta_inx);
mu_beta.N_DFT = N_DFT_list(beta_inx);
mu_beta.N_cp = N_cp_list(mu_inx);
mu_beta.B_mubeta_DFT = mu_beta.Delta_mu_f*mu_beta.N_DFT;
mu_beta.T_mubeta_s = 1/mu_beta.B_mubeta_DFT;
mu_beta.N_beta_occ = N_occ_list(mu_inx);
mu_beta.B_mubeta_tx = mu_beta.Delta_mu_f*(mu_beta.N_beta_occ+1);

end