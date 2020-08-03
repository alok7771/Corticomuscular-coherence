function C_WN_autocode_pooled_TD(EEG_ch_no,EMG_ch_no,leg)
% clear all;clc;
%% does the time dependent pooled analysis for an already generated output
%which has f,t,cl,sc values already stored in it. finds the file in a
%folder. only the location of folder is needed to be given. using that
%location, it generates one folder inside it and saves pooled results to
%that folder.
%% select folder to solve the pooled analysis for
addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory');
ch_data=readtable('channel_data.xlsx');
fold_path='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WN';
sf_path= 'EEG_EMG_%s_%s_%s';
f_path=sprintf(sf_path,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
folder_path=strcat(fold_path,'\',f_path);
addpath(folder_path);
%% import data file
load('output_TD.mat');
%% Create output folder
subfname=strcat('T_D_',pool_name);
mkdir(fname,subfname);
sfpath=strcat(fname,'\',subfname);

addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Neurospec_main');
%% the pool code
offset=round(offset);

for iter=1:size(op_TD,3)
    field_data=cell2mat(op_TD(1,1,iter));
    F=field_data.f; T=field_data.t; CL=field_data.cl; SC=field_data.sc; SUBJ=field_data.subj;
            for ofst=1:length(offset)
                f1(ofst,1)={F(:,:,ofst)}; t1(ofst,1)={T(:,:,ofst)}; cl1(ofst,1)={CL(:,ofst)}; sc1(ofst,1)={SC(:,:,ofst)};
            end
            f2(iter,:)=f1; t2(iter,:)=t1; cl2(iter,:)=cl1; sc2(iter,:)=sc1;
end
%%%%%%% i for row, j for column %%%%%%%
for j=1:size(f2,2)
    for i=1:size(f2,1)
                if (i==1)
                    %%Separate call for first set, creates new pooled analysis.
                    [plf1,plv1]=pool_scf(cell2mat(sc2(i,j)),cell2mat(cl2(i,j)));
                else
                    %%Pass pooled variables as arguments for further sets.
                    [plf1,plv1]=pool_scf(cell2mat(sc2(i,j)),cell2mat(cl2(i,j)),plf1,plv1);

                end
               plf(:,:,j)=plf1;
               plv(:,j)=plv1;
    end
end

%% Process pooled spectral coefficients & plot
for n=1:size(plf,3)
[f3,t3,cl3,sc3]=pool_scf_out(plf(:,:,n),plv(:,n));
cl3.type=2;  %% type and offset fields are missing from the cl struct thats how included
cl3.offset=offset(n);
cl3.what=pool_name;
f4(:,:,n)=f3; t4(:,:,n)=t3; cl4(:,n)=cl3; sc4(:,:,n)=sc3;
end

%% Plotting parameters
chi_max=0;% Will auto scale
freq=70;
lag_tot=250;
lag_neg=125;
ch_max=0.005;
samp_rate=256;
seg_pwr=6;
opt_str='';
t_inc=0;
n_contour=10;
line_flag=0;

%% Plot
[h,hh]=psp2_tf_alok_pool(f4,t4,cl4,freq,lag_tot,lag_neg,t_inc,n_contour,line_flag);
%% save pooled output
f=f4; t=t4;cl=cl4;sc=sc4;
save(fullfile(sfpath,'output_pooled_TD'),'f','t','cl','sc','pool_name','offset');
%% save plot
saveas(h,fullfile(sfpath,strcat('C_WN_',pool_name,'_1','.png')));
saveas(h,fullfile(sfpath,strcat('C_WN_',pool_name,'_1','.fig')));
saveas(hh,fullfile(sfpath,strcat('C_WN_',pool_name,'_2','.png')));
saveas(hh,fullfile(sfpath,strcat('C_WN_',pool_name,'_2','.fig')));

close all;
end
%%