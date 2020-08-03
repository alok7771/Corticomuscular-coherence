function [f,t,cl,sc,fname,pool_name]= PD_WEA_EEG_EMG_solver(EEG,EMG,EEG_ch_no,EMG_ch_no,triggers,leg,k,imagedir,vfigdir,vpngdir,num)

%% Choosing trigger values to be used
trig_all=triggers.(leg(1,:));
trig = trig_all(~isnan(trig_all))/2;

%% High pass filter
EMG_Hfilt=highpass(EMG,5,256); % high pass filter of 5 Hz %%compensates for the delay%%
%% Low pass filter
% EMG_Lfilt=lowpass(EMG_Hfilt,128,256); % low pass filter of 1000 Hz %%compensates for the delay%%
%% DATA 
dat=[EEG EMG_Hfilt];
%% parameters
seg_pts=128; % No of data points in each segment (samples)
samp_rate=256; %No of data points in per second
seg_pwr=7; % DFT length for time-freq analysis
opt_str='t2 r1';% Options
offset=-(950*(256/1000));% Offset values (in samples) for TYPE 2 time-frequency analysis.

freq=70;
lag_tot=500;
lag_neg=250;
ch_max=0.25;

%% operations
addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Neurospec_main');
[f,t,cl,sc]=sp2a2_m1(2,dat(:,1),dat(:,2),trig,offset,seg_pts,samp_rate,seg_pwr,opt_str);
addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory');
ch_data=readtable('channel_data.xlsx');
fig_n='EEG %s vs EMG %s %s subj %s';
fig_name=sprintf(fig_n,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}),num);
pool_n='Pooled Analysis- EEG %s vs EMG %s %s';
pool_name=sprintf(pool_n,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
cl(1).what=fig_name;
% save('WEA31.mat','f','t','cl','sc');
% Plot using new routine, using default no of contours, and default line flag.
% psp2_tf(f,t,cl,freq,lag_tot,lag_neg,t_inc,n_contour,line_flag,coh_contour)
%% plot 2D time independent and save in specified directory
h=figure;
h.PaperUnits = 'inches';
h.PaperPosition = [0 0 12 6];
% label=cl(1).what; %% using this will overwright the actual coh,q etc
% embedded in the psp2 code
psp2(f,t,cl,freq,lag_tot,lag_neg,ch_max);
namedir='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\PD Group\PD_WEA\';
fname=strcat(namedir,char(imagedir));
saveas(h,fullfile(strcat(namedir,char(imagedir),'\',char(vpngdir)),strcat('PD_WEA_',fig_name,'.png')));
saveas(h,fullfile(strcat(namedir,char(imagedir),'\',char(vfigdir)),strcat('PD_WEA_',fig_name,'.fig')));
close 

end
