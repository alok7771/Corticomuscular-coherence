function [f,t,cl,sc,fname,pool_name,offset]= PD_WN_EEG_EMG_solver_TD(EEG,EMG,EEG_ch_no,EMG_ch_no,triggers,leg,imagedir,vfigdir,vpngdir,num)


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
seg_pts=64; % No of data points in each segment (samples)
samp_rate=256; %No of data points in per second
seg_pwr=6; % DFT length for time-freq analysis
opt_str='t2 r1';% Options
offset=[(-1100*(256/1000)):(50*256/1000):(0*(256/1000))]';% Offset values (in samples) for TYPE 2 time-frequency analysis.

freq=70;
lag_tot=250;
lag_neg=125;
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
%% plot 2D time independent and save in specified directory
% h=figure;
% hh=figure;
% hhh=figure;
namedir='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\PD Group\PD_WN\';
fname=strcat(namedir,char(imagedir));
% t_inc=0;
% n_contour=10;
% line_flag=0;
% coh_contour=0;
[h,hh]= psp2_tf_alok(f,t,cl,freq,lag_tot,lag_neg); %% for TD plot
saveas(h,fullfile(strcat(namedir,char(imagedir),'\',vpngdir),strcat('PD_WN_',fig_name,'_1','.png')));
saveas(h,fullfile(strcat(namedir,char(imagedir),'\',vfigdir),strcat('PD_WN_',fig_name,'_1','.fig')));
saveas(hh,fullfile(strcat(namedir,char(imagedir),'\',vpngdir),strcat('PD_WN_',fig_name,'_2','.png')));
saveas(hh,fullfile(strcat(namedir,char(imagedir),'\',vfigdir),strcat('PD_WN_',fig_name,'_2','.fig')));
close all
end
