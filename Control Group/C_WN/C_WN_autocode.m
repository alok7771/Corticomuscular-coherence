function [op,pool_name,fname]=C_WN_autocode(EEG_ch_no,EMG_ch_no,leg)
% EEG_ch_no --->  provide the numerical value of EEG channel
% EMG_ch_no --->  provide the numerical value of EMG channel
%       leg --->  provide the string for the trigger and leg which you are solving
%                   There are four options ['LHS','RTO','RHS','LTO']
%                   format example (like a string entry to a structure) ---->  'LHS'
%        op --->  stores [f,t,cl,sc,subj] values in a cell array, which can
%                   be accessed later for pooled analysis

%% This function is calling an another function "C_WN_EEG_EMG_solver", which
% solves for time independent plot. The purpose of this function is to
% generate correct directories and save the output in that directory.

%% Define directries and main data file
filename = 'C_WN_dat_EEG_EMG_2018.mat';
triggerdir = 'C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WN\C_WN_trig';
mystruct = load(filename);
fn = fieldnames(mystruct);
%% Create a directory to save image files
addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory');
ch_data=readtable('channel_data.xlsx');
path_dir='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WN';
imag= 'EEG_EMG_%s_%s_%s';
vfig= 'T_IND Fig version EEG_EMG_%s_%s_%s';
vpng= 'T_IND Png version EEG_EMG_%s_%s_%s';
imagedir=sprintf(imag,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
vfigdir=sprintf(vfig,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
vpngdir=sprintf(vpng,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
mkdir(path_dir,imagedir);
mkdir(path_dir,strcat(imagedir,'\',vfigdir));
mkdir(path_dir,strcat(imagedir,'\',vpngdir));


%% Looping to search the trigger files
for k=1:numel(fn)
    if( isnumeric(mystruct.(fn{k})) )
        data=mystruct.(fn{k});
        EEG=data(:,EEG_ch_no);
        EMG=data(:,EMG_ch_no);
     %% find the string in trigger folder to match
        T  = convertCharsToStrings(fn{k}); 
        num = regexp(T, '\d+', 'match');
        %triggerfiles = dir(fullfile(triggerfolder,num,'*.xls'));
        trig_str = sprintf('%s_WN_triggers.xlsx', num);
        addpath(triggerdir);
        triggers=readtable(trig_str);
        
%%      ENTER THE FUNCTION CODE HERE
        
        [f,t,cl,sc,fname,pool_name]= C_WN_EEG_EMG_solver(EEG,EMG,EEG_ch_no,EMG_ch_no,triggers,leg,k,imagedir,vfigdir,vpngdir,num);
        opp= struct('f',f,'t',t,'cl',cl,'sc',sc,'subj',trig_str);
        op(1,1,k)={opp};
        %%%%%%%%%%%%%%pp=cell2mat(op(1,1,1))%%%%%%%%pp.f%%%%%%%%for accessing data%%%
    end

end
save(fullfile(fname,'output_T_IND'),'op','pool_name','fname');
end