function panacea(EEG_ch_no,EMG_ch_no,leg)

tic
addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WN');
[op,pool_name,fname]=C_WN_autocode(EEG_ch_no,EMG_ch_no,leg);
% [op_TD,pool_name,fname]=C_WN_autocode_TD(EEG_ch_no,EMG_ch_no,leg);
C_WN_autocode_pooled(EEG_ch_no,EMG_ch_no,leg);
% C_WN_autocode_pooled_TD(EEG_ch_no,EMG_ch_no,leg);


addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WEA');
[op,pool_name,fname]=C_WEA_autocode(EEG_ch_no,EMG_ch_no,leg);
% [op_TD,pool_name,fname]=C_WEA_autocode_TD(EEG_ch_no,EMG_ch_no,leg);
C_WEA_autocode_pooled(EEG_ch_no,EMG_ch_no,leg);
% C_WEA_autocode_pooled_TD(EEG_ch_no,EMG_ch_no,leg);


addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\PD Group\PD_WN');
[op,pool_name,fname]=PD_WN_autocode(EEG_ch_no,EMG_ch_no,leg);
% [op_TD,pool_name,fname]=PD_WN_autocode_TD(EEG_ch_no,EMG_ch_no,leg);
PD_WN_autocode_pooled(EEG_ch_no,EMG_ch_no,leg);
% PD_WN_autocode_pooled_TD(EEG_ch_no,EMG_ch_no,leg);


addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\PD Group\PD_WEA');
[op,pool_name,fname]=PD_WEA_autocode(EEG_ch_no,EMG_ch_no,leg);
% [op_TD,pool_name,fname]=PD_WEA_autocode_TD(EEG_ch_no,EMG_ch_no,leg);
PD_WEA_autocode_pooled(EEG_ch_no,EMG_ch_no,leg);
% PD_WEA_autocode_pooled_TD(EEG_ch_no,EMG_ch_no,leg);


addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\comp_coh');
% comp_coh_fn(EEG_ch_no,EMG_ch_no,leg);
toc

end