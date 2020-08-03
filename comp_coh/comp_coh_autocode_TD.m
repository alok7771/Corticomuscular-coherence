clear all;clc;
%% does the time dependent comparision of coherences for an already generated output
%which has f,t,cl,sc values already stored in it. finds the file in a
%folder. only the location of folder is needed to be given. using that
%location, it picks up the file does the necessory and gives output
%% select folder to solve the pooled analysis for
folder_path1='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WN\EEG_EMG_Cz_TA2_right\T_D_Pooled Analysis- EEG Cz vs EMG TA2 right';
% uigetdir();
addpath(folder_path1);
folder_path2='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\PD Group\PD_WN\EEG_EMG_Cz_TA2_right\T_D_Pooled Analysis- EEG Cz vs EMG TA2 right';
% uigetdir();
addpath(folder_path2);
%% find what vs what
if isempty([strfind(folder_path1,'C_WN')])==0
        case1='C_WN';
    elseif     isempty([strfind(folder_path1,'C_WEA')])==0
        case1='C_WEA';
    elseif    isempty([strfind(folder_path1,'PD_WN')])==0
        case1='PD_WN';
    elseif    isempty([strfind(folder_path1,'PD_WEA')])==0
        case1='PD_WEA';
    else
    disp('no match for case1');
end

if isempty([strfind(folder_path2,'C_WN')])==0
    case2='C_WN';
    elseif     isempty([strfind(folder_path2,'C_WEA')])==0
        case2='C_WEA';
    elseif    isempty([strfind(folder_path2,'PD_WN')])==0
        case2='PD_WN';
    elseif    isempty([strfind(folder_path2,'PD_WEA')])==0
        case2='PD_WEA';
    else
    disp('no match for case2');
end
%% import data file
caseA=load(strcat(folder_path1,'\output_pooled_TD.mat'));
caseB=load(strcat(folder_path2,'\output_pooled_TD.mat'));
% both cases should be same (in therms of electrodes) to compare to generate the correct name for the folder
%% Create output folder
subfname=strcat('Comp of_',caseA.pool_name);
fname='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\comp_coh';
mkdir(fname,subfname);
sfpath=strcat(fname,'\',subfname);

%% Create output folder
 
addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Neurospec_main');
%% the pool code
 
for iter=1:length(caseA.offset)
    f1=caseA.f(:,:,iter); t1=caseA.t(:,:,iter); cl1=caseA.cl(:,iter); sc1=caseA.sc(:,:,iter); 
    f2=caseB.f(:,:,iter); t2=caseB.t(:,:,iter); cl2=caseB.cl(:,iter); sc2=caseB.sc(:,:,iter);
    aa=cl1.seg_tot_var; cl2.seg_tot_var=aa;
    offset(iter)=cl1.offset;
    t_axis=offset*1000/256;
    [f3(:,:,iter),cl3(:,iter)] = sp2_compcoh(sc1,cl1,sc2,cl2);
    aa=f3(:,:,iter);
    f4(iter,:)=[aa(:,2)'];
    f_axis=aa(:,1);

end
    p=figure;
     f4(find((f4<(cl3(1).cmpcoh_c95)) & (f4>-(cl3(1).cmpcoh_c95))))=0.0;
%     f4(find((f4<(cl1(1).ch_c95))& f4>0))=0.0;
%     f4(find((f4>-(cl1(1).ch_c95)) & f4<0))=0.0;%%% check for CI lower and upper both limits C95%% 
    [C,h]=contourf(t_axis,f_axis,f4');
  
  colormap jet
  H=colorbar;
  caxis([-0.1 0.1]);
  set(h(:),'LineStyle','none')
  freq=70;
  axis([min(t_axis),max(t_axis),min(f_axis),freq]);
  xlabel('Offset (ms)')
  ylabel('Frequency (Hz)')
  title(['cmpcoh: ',cl1.what]);
%   c95_bar= [-cl3(1).cmpcoh_c95,-cl3(1).cmpcoh_c95,cl3(1).cmpcoh_c95,cl3(1).cmpcoh_c95];
% h_line_cbar = line([-cl3(1).cmpcoh_c95,-cl3(1).cmpcoh_c95],[cl3(1).cmpcoh_c95,cl3(1).cmpcoh_c95],'color','k','linewidth',4);
%     line('parent',H,'xdata',[-0.08 0.08],...
%      'ydata',[0 0],'color','k','LineWidth',3);
%  hold on
% [~,H] = contourf(peaks,[0 0]); %contour handles
% set(allchild(H),'FaceAlpha',0,...
%     'LineWidth',3,'EdgeColor','k'); %children are patches
% hold on;
% H=plot();