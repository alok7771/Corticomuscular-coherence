function PD_WEA_autocode_pooled(EEG_ch_no,EMG_ch_no,leg)
%% select folder to solve the pooled analysis for
addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory');
ch_data=readtable('channel_data.xlsx');
fold_path='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\PD Group\PD_WEA';
sf_path= 'EEG_EMG_%s_%s_%s';
f_path=sprintf(sf_path,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
folder_path=strcat(fold_path,'\',f_path);
addpath(folder_path);
%% import data file
load('output_T_IND.mat');
%% Create output folder
subfname=strcat('T_IND_',pool_name);
mkdir(fname,subfname);
sfpath=strcat(fname,'\',subfname);

%% the pool code
samp_rate=256;
seg_pwr=8;
opt_str='';

for ind=1:size(op,3)
    field_data=cell2mat(op(1,1,ind));
F=field_data.f; T=field_data.t; CL=field_data.cl; SC=field_data.sc; SUBJ=field_data.subj;
if (ind==1)
    % Separate call for first set, creates new pooled analysis.
    [plf1,plv1]=pool_scf(SC(:,:),CL(:,1));
  else
    % Pass pooled variables as arguments for further sets.
    [plf1,plv1]=pool_scf(SC(:,:),CL(:,1),plf1,plv1);
  end
end

%% Plotting parameters
chi_max=0;% Will auto scale
freq=70;
lag_tot=500;
lag_neg=250;
ch_max=0.005;

%% Process pooled spectral coefficients & plot
[f2,t2,cl2]=pool_scf_out(plf1,plv1);
h=figure;
h.PaperUnits = 'inches';
h.PaperPosition = [0 0 12 6];
cl2.what=pool_name;
psp2_pool6(f2,t2,cl2,freq,lag_tot,lag_neg,ch_max,chi_max);
saveas(h,fullfile(sfpath,strcat('PD_WEA_',pool_name,'.png')));
saveas(h,fullfile(sfpath,strcat('PD_WEA_',pool_name,'.fig')));
close;
end
