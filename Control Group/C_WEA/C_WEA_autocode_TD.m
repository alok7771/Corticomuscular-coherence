function [op_TD,pool_name,fname]=C_WEA_autocode_TD(EEG_ch_no,EMG_ch_no,leg)
% EEG_ch_no --->  provide the numerical value of EEG channel
% EMG_ch_no --->  provide the numerical value of EEG channel
%       leg --->  provide the string for the trigger and leg which you are solving
%                   There are four options ['LHS','RTO','RHS','LTO']
%                   format example (like a string entry to a structure) ---->  'LHS'
%        op --->  stores [f,t,cl,sc,subj] values in a cell array, which can
%                   be accessed later for pooled analysis

%% Define directries and main data file
filename = 'C_WEA_dat_EEG_EMG_2018.mat';
triggerdir = 'C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WEA\C_WEA_trig';
mystruct = load(filename);
fn = fieldnames(mystruct);
%% Create a directory to save image files
addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory');
ch_data=readtable('channel_data.xlsx');
path_dir='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WEA';
imag= 'EEG_EMG_%s_%s_%s';
vfig= 'T_D Fig version EEG_EMG_%s_%s_%s';
vpng= 'T_D Png version EEG_EMG_%s_%s_%s';
imagedir=sprintf(imag,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
vfigdir=sprintf(vfig,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
vpngdir=sprintf(vpng,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
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
        trig_str = sprintf('%s_WEA_triggers.xlsx', num);
        addpath(triggerdir);
        triggers=readtable(trig_str);
        
%%      ENTER THE FUNCTION CODE HERE
        
           [f,t,cl,sc,fname,pool_name,offset]= C_WEA_EEG_EMG_solver_TD(EEG,EMG,EEG_ch_no,EMG_ch_no,triggers,leg,imagedir,vfigdir,vpngdir,num);
                opp_TD= struct('f',f,'t',t,'cl',cl,'sc',sc,'subj',trig_str);
             op_TD(1,1,k)={opp_TD};
    end
end
save(fullfile(fname,'output_TD'),'op_TD','pool_name','fname','offset');
end