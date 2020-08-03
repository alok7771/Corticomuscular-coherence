tic
%% runs the combinations you want to generate results for
%% adjust in function 'panacea' for selected results
%% adjust in particular Tind and Td function for trigger time and segment length
%% example for data entry
%%EEG=[6 12];   EMG=[43 39]; side=[{'RHS'} {'LHS'}];
%% it means 6th eeg channel vs 43rd emg channel using trigers of right heel strike
%% 12th eeg vs 39th emg using triggers of left heel strike
%% tic and toe are used for time calculation of simulation run
EEG=[6 12];   
EMG=[43 43];
side=[{'RHS'} {'RHS'}];
for i=1:length(EEG)
    EEG_ch_no=EEG(i);
    EMG_ch_no=EMG(i);
    leg=cell2mat(side(i));
    panacea(EEG_ch_no,EMG_ch_no,leg);
end
toc