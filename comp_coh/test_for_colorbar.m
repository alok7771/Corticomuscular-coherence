% function comp_coh_fn(EEG_ch_no,EMG_ch_no,leg)
EEG_ch_no=11;EMG_ch_no=39;,leg='RHS';
f_path_a='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WN';
f_path_b='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Control Group\C_WEA';
f_path_c='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\PD Group\PD_WN';
f_path_d='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\PD Group\PD_WEA';

addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory');
ch_data=readtable('channel_data.xlsx');

sf1name='EEG_EMG_%s_%s_%s';
sf2name='T_D_Pooled Analysis- EEG %s vs EMG %s %s';
subf1name=sprintf(sf1name,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
subf2name=sprintf(sf2name,char(ch_data{EEG_ch_no,2}),char(ch_data{EMG_ch_no,2}),char(ch_data{EMG_ch_no,3}));
folder_path1=strcat(f_path_a,'\',subf1name,'\',subf2name,'\output_pooled_TD.mat');
folder_path2=strcat(f_path_b,'\',subf1name,'\',subf2name,'\output_pooled_TD.mat');
folder_path3=strcat(f_path_c,'\',subf1name,'\',subf2name,'\output_pooled_TD.mat');
folder_path4=strcat(f_path_d,'\',subf1name,'\',subf2name,'\output_pooled_TD.mat');

caseA=load(folder_path1);
caseB=load(folder_path2);
caseC=load(folder_path3);
caseD=load(folder_path4);


for iter=1:length(caseA.offset)
    f1=caseA.f(:,:,iter); t1=caseA.t(:,:,iter); cl1=caseA.cl(:,iter); sc1=caseA.sc(:,:,iter); 
    f2=caseB.f(:,:,iter); t2=caseB.t(:,:,iter); cl2=caseB.cl(:,iter); sc2=caseB.sc(:,:,iter);
    f3=caseC.f(:,:,iter); t3=caseC.t(:,:,iter); cl3=caseC.cl(:,iter); sc3=caseC.sc(:,:,iter); 
    f4=caseD.f(:,:,iter); t4=caseD.t(:,:,iter); cl4=caseD.cl(:,iter); sc4=caseD.sc(:,:,iter); 
    
    %% to proceed from the limitation of cl comparision in sp2_compcoh
    segments=cl1.seg_tot_var;
    cl2.seg_tot_var=segments;
    cl3.seg_tot_var=segments;
    cl4.seg_tot_var=segments;
   
    offset(iter)=cl1.offset;
    t_axis=offset*1000/256;
    
   addpath('C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\Neurospec_main'); 
    %% comparision calculation
    [f5(:,:,iter),cl5(:,iter)] = sp2_compcoh(sc1,cl1,sc2,cl2);
    [f6(:,:,iter),cl6(:,iter)] = sp2_compcoh(sc3,cl3,sc4,cl4);
    [f7(:,:,iter),cl7(:,iter)] = sp2_compcoh(sc1,cl1,sc3,cl3);
    [f8(:,:,iter),cl8(:,iter)] = sp2_compcoh(sc2,cl2,sc4,cl4);
    [f9(:,:,iter),cl9(:,iter)] = sp2_compcoh(sc1,cl1,sc4,cl4);
    
    CCDM5=f5(:,:,iter);CCDM6=f6(:,:,iter);CCDM7=f7(:,:,iter);CCDM8=f8(:,:,iter);CCDM9=f9(:,:,iter);
   CCCL5=cl5(:,iter);
    f5_1(iter,:)=CCDM5(:,2)';
    f6_1(iter,:)=CCDM6(:,2)';
    f7_1(iter,:)=CCDM7(:,2)';
    f8_1(iter,:)=CCDM8(:,2)';
    f9_1(iter,:)=CCDM9(:,2)';
    f_axis=CCDM5(:,1);

end
f5_1(find((f5_1<(cl5(1).cmpcoh_c95)) & (f5_1>-(cl5(1).cmpcoh_c95))))=0.0;
f6_1(find((f6_1<(cl6(1).cmpcoh_c95)) & (f6_1>-(cl6(1).cmpcoh_c95))))=0.0;
f7_1(find((f7_1<(cl7(1).cmpcoh_c95)) & (f7_1>-(cl7(1).cmpcoh_c95))))=0.0;
f8_1(find((f8_1<(cl8(1).cmpcoh_c95)) & (f8_1>-(cl8(1).cmpcoh_c95))))=0.0;
f9_1(find((f9_1<(cl9(1).cmpcoh_c95)) & (f9_1>-(cl9(1).cmpcoh_c95))))=0.0;


freq=70;
n_contour=10;
colorbar_flag=1;
line_flag=0;
mask_flag=1;

t=strcat('Comp Coh- ',cl1(1).what);
p=figure;
p.Name=t;
% p.PaperSize=[35 55];
p.PaperUnits = 'inches';
p.PaperPosition = [0 0 13 7.5];
suptitle({t,''});

 subplot(3,1,1)
       psptf_ch1a_alok_pool_comp(caseA.f,caseA.cl,freq,n_contour,colorbar_flag,line_flag,mask_flag);
title('C-WN');
 subplot(3,1,2)
       psptf_ch1a_alok_pool_comp(caseC.f,caseC.cl,freq,n_contour,colorbar_flag,line_flag,mask_flag);
title('PD-WN');
 
  
  subplot(3,1,3)
       [C,h7]=contourf(t_axis,f_axis,f5_1');
      title('C-WN vs C-WEA');
      colormap jet
      H7=colorbar;


      
      caxis([-0.1 0.1]);
      set(h7(:),'LineStyle','none')
      freq=70;
      axis([min(t_axis),max(t_axis),min(f_axis),freq]);
      xlabel ('Offset (ms)')
      ylabel ('Frequency (Hz)')

 
fname='C:\Users\Alok Ranjan\Dropbox\BME coursework\2b\Internship\Data Alok\Working_directory\My codes\comp_coh';
mkdir(fname,t)
    saveas(p,fullfile(fname,strcat(t,'\',t,'.png')));
    saveas(p,fullfile(fname,strcat(t,'\',t,'.fig')));
%     close 
%  end