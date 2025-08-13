%This code computes the analysis presented in Rogge-Obando et al., 2024 mediarchive

%Author: Kim Kundert-Obando and Dr. Catie Chang for questions please reach out to me at k.rogge.obando@gmail.com

%write to clear the code 
clear; clc; close all; 

%Load envirionment

loadenv("globalfMRI_anx_proj_MATLAB_env.env")


% mask out the skull (nonzero voxels)
mni_mask = niftiread(MNI_MASK);
brainVox = find(mni_mask>0);

% define parameters
TR = 1.4;

% Load ICA mask that has 40 components
ica_mask = niftiread(ICA_MASK);

% Assemble maps into matrix
ica_dims = size(ica_mask);
ica_comp_tot=ica_dims(4);
Xnets_0=[];
for comp = 1 : ica_comp_tot
    ica_comp= ica_mask(:,:,:,comp);
    comp_Xnets_0 = ica_comp(brainVox);
    Xnets_0(comp,:)=[comp_Xnets_0];
end
Xnets_1=Xnets_0';
Xnets = [ones(size(Xnets_1,1),1),  zscore(Xnets_1)];

% load arousal template also known as vigilance template
arousal_template = niftiread(AROUSAL_TEMPLATE); %this can be downloaded at https://github.com/neurdylab/fMRIAlertnessDetection

% reshape template from 3-D to 1-D to be a vector
  
    temp_reshape = reshape(arousal_template,[],1);
    temp_mask = temp_reshape(brainVox);

%this is the text file that will load in all the subject that was corrected using fix_ica
subj= readtable(MAIN_PATH,'/great_HR_sub_coded.txt', 'readvariablenames', 0);

% where to save the outputs for each subject
save_path = SAVE_PATH;
mkdir(save_path);

% set up matrices that will store data for all subjects
% store FC after various regressions
regG_allsub = [];
regA_allsub = []; 
regH_allsub = [];
regAll_allsub = [];
regAG_allsub = [];
noreg_allsub = [];
% store time-course correlations
corrsG_allsub = [];
corrsA_allsub = [];
corrsH_allsub = [];
corrsAG_allsub = [];
corrsHA_allsub = [];
corrsHG_allsub = [];

%store spatial maps

global_signal_filename_ps_all=[];
global_signal_filename_z_all=[];




subject_IDs = {};
  
for subject = 1:height(subj)

    this_subject = subj{subject,1}{1}
    subject_IDs{subject} = this_subject;

    % load fMRI file names
    nii_name = [this_subject,'_ses-BAS1_task-rest_acq-1400_bold_mo_FIX_EPI2MNI_sm_nr.nii.gz'];
    subj_dir=[fix_path,this_subject,'/fix_ants_out/',nii_name];
    subj_fmri = niftiread(subj_dir); 

    %reformat the fMRI file
    dims = size(subj_fmri);
    subj_V2 = reshape(subj_fmri,prod(dims(1:3)),size(subj_fmri,4));
    subj_V_mask = subj_V2(brainVox,:);
    Y = subj_V_mask';
    
    %Grand mean scaling
    mean_4D=mean(Y(:));
    Y_scaled=1000*Y/mean_4D;

    %Load motion parameters
    par_name = [this_subject,'_ses-BAS1_task-rest_acq-1400_bold_mo.nii.gz.par'];
    par_dir=[main_path,this_subject,'/ses-BAS1/func/',par_name];

    par_file  =load(par_dir);
    dMP=diff(par_file);
    dMP = [dMP(1,:); dMP];

    %remove motion parameters %hm is head motion
    X_hm = [ones(size(par_file,1),1), zscore(par_file),zscore(dMP)];
    betas_hm = pinv(X_hm) * Y_scaled;
    hm_confound = X_hm(:,2:end) * betas_hm(2:end,:);
    Y_hm_removed = Y_scaled - hm_confound; % this will be a new fmri with head motion removed
   
    % spatial regression against this subject's fMRI data
    %  -> results in network time courses
    betas_r1 = pinv(Xnets)*Y_hm_removed';
    % the rows of betas_r1 correspond to the network time courses
    % the first row should be ignored (mean offset)

    % temporal regression -> results in subject-specific spatial maps
    betas_r1_ones = [ones(size(betas_r1',1),1), zscore(betas_r1(2:41,:)')];
    betas_r2 = pinv(betas_r1_ones)*Y_hm_removed;
    % the rows of betas_r2 correspond to spatial maps tailored to this subject
    % (ignore the first row)

    %identifying timeseries of each network of interest.
    ica_d_dmn_ts=zscore(betas_r1(8,:));
    ica_v_dmn_ts=zscore(betas_r1(9,:));
    ica_sal_ts=zscore(betas_r1(7,:));
    ica_lcen_ts=zscore(betas_r1(18,:));
    ica_rcen_ts=zscore(betas_r1(6,:));

    network_signals = [ica_d_dmn_ts',ica_v_dmn_ts',ica_sal_ts',ica_lcen_ts',ica_rcen_ts'];
 

    % save relevant ICA outputs for this subject
    ICA_component_ts=zscore(betas_r1(2:end,:)');
    ICA_component_spatial_map= betas_r2(2:end,:);

    ica_output_subj = [save_path, '/', this_subject, '_ICA_out.mat'];
    save(ica_output_subj, 'ICA_component_ts', 'ICA_component_spatial_map');
    

    % create this subj's global components
    % ---------------------------------------- %
    
    %% create global signal time course (without zscore)
    global_signal_tc= mean(Y_hm_removed'); 
    global_signal_filename = [save_path,'/',this_subject,'_global_signal_tc.mat']
    save(global_signal_filename,'global_signal_tc')
    
    
    %% create global signal maps (possibly 2 versions)
    %converting Y voxels to percent signal change
    Y_new=100*(Y_hm_removed - mean(Y_hm_removed,1)) ./ mean(Y_hm_removed,1);

    %zscoring Y_new
    Y_zscore= zscore(Y_hm_removed); %Check to be zscoring across time dimension as rows
   
    %generating model X that contains an array of Ones for the intercept
    Ones=ones(404,1);
    X_gs = [Ones,zscore(global_signal_tc')];
    
    %solving for betas
    Beta_gs_ps = pinv(X_gs)*Y_new;
    Beta_gs_z = pinv(X_gs)*Y_zscore;
    
    %deriving the global signal spatial map
    global_signal_map_ps=Beta_gs_ps(2,:);
    global_signal_map_z =Beta_gs_z(2,:);

    %save global signal maps
    global_signal_filename_ps = [save_path,'/',this_subject,'_global_signal_map_ps.mat']
    save(global_signal_filename_ps,'global_signal_map_ps')

    global_signal_filename_ps_all(subject,:)=[global_signal_map_ps];

    global_signal_filename_z = [save_path,'/',this_subject,'_global_signal_map_z.mat']
    save(global_signal_filename_z,'global_signal_map_z')
   
%% create arousal signal time course -> arousal_signal

    % normalize along time dimension
    V_zscored = zscore(Y_hm_removed)'; % output is (vox x time)

    % correlate V_mask against template
    arousal_tc = corr(V_zscored,temp_mask);
    %figure; plot(vig_tc);
    
    %save tc
    arousal_filename = [save_path, '/', this_subject,'_arousal_tc.mat'];
    save(arousal_filename,"arousal_tc")

    % arousal map
    Ones=ones(404,1);
    X_arousal = [Ones,zscore(arousal_tc)];
    Beta_A = pinv(X_arousal)*Y_zscore;
    arousal_map=Beta_A(2,:);
    
    %save map
    arousal_sm_filename = [save_path, '/', this_subject,'_arousal_sm.mat'];
    save(arousal_sm_filename,"arousal_map")


    %% create heart rate time course and percent variation maps
    % load the physio file for this subject, create 5 regressors -> HR_basis

    if subj.Var2(subject) == 1 %a 1 here indicates that this subject had clean HR

        % load physio file
        physio_file=[PREPROC_PHYSIO_PATH,this_subject,'/',this_subject,'_ses-BAS1_task-rest_acq-1400_physio_physOUT.mat'];
        physio_data = load(physio_file);

        % Extract the HR time series from the 'REGS' field
        hr = zscore(physio_data.REGS.hr);
        hr_signal=hr;
        % Make HR regressors:
        HR_basis = create_hr_basis_dt(hr, TR);
        v1 = ones(size(hr, 1), 1);
        X1_hr = [v1 HR_basis];  % controlling for HR

        % save hr timecourse and basis:
        hr_filename = [save_path, '/', this_subject,'_hr_tc.mat']
        save(hr_filename, 'hr','HR_basis')
       
        % create HR percent variance map
        betas_hr = pinv(X1_hr) * Y_hm_removed; 
        hr_confound = X1_hr(:,2:end) * betas_hr(2:end,:);
        Y_hr = Y_hm_removed - hr_confound; % this will be a new fMRI with HR removed
        hr_percent_variance_map = var(hr_confound) ./  var(Y_hm_removed);
        hr_file_name=[save_path, '/', this_subject,'_hr_map'];
        save(hr_file_name,"hr_percent_variance_map")
    else 
        hr_signal=NaN(404,1);
        HR_basis = NaN(404,5);
    end
    
    
%% Conduct subject regression of global components

% time courses of interest
global_signal= global_signal_tc';
arousal_signal=arousal_tc;
hr_basis_signals=HR_basis; % true or nans, depending on if HR exists
all_signals=[global_signal, arousal_signal, hr_basis_signals];
a_g_signals=[global_signal, arousal_signal];

% calculate time courses and network FC after regressing
% various signals
[regressed_A_tc, regressed_A_fc] = regress_tc(network_signals, arousal_signal);
[regressed_G_tc, regressed_G_fc] = regress_tc(network_signals, global_signal);
[regressed_AG_tc, regressed_AG_fc] = regress_tc(network_signals, a_g_signals);
% depend on HR:
[regressed_H_tc, regressed_H_fc] = regress_tc(network_signals, hr_basis_signals);
[regressed_All_tc, regressed_All_fc]=regress_tc(network_signals, all_signals);


% also calculate time courses and FC before regressinng
orig_tc = network_signals;
orig_fc = corr(network_signals);

% store the data for this subject
regression_analysis_filename=[save_path,'/',this_subject,'_regression_analysis_out.mat']
save(regression_analysis_filename, ...
     'regressed_A_tc', 'regressed_A_fc', ...
     'regressed_G_tc', 'regressed_G_fc', ...
     'regressed_H_tc', 'regressed_H_fc', ...
     'regressed_All_tc', 'regressed_All_fc', ...
     'regressed_AG_tc', 'regressed_AG_fc', ...
     'orig_tc', 'orig_fc');

% store flattened values for this subject
regA_allsub(subject,:) = retrieve_fc_values(regressed_A_fc);
regG_allsub(subject,:) = retrieve_fc_values(regressed_G_fc);
regAG_allsub(subject,:) = retrieve_fc_values(regressed_AG_fc);
noreg_allsub(subject,:) = retrieve_fc_values(orig_fc);
% depend on HR:
regH_allsub(subject,:) = retrieve_fc_values(regressed_H_fc);
regAll_allsub(subject,:) = retrieve_fc_values(regressed_All_fc);


%% look at relationships between time courses:
% global signal to networks:
corrsG_allsub(subject,:) = corr(global_signal, network_signals);
corrsA_allsub(subject,:) = corr(arousal_signal, network_signals);
corrsH_allsub(subject,:) = xcov_signals(hr_signal,network_signals);

%global components to global components
corrsAG_allsub(subject,:) = corr(global_signal, arousal_signal);
corrsHA_allsub(subject,:) = xcov_signals(hr_signal,arousal_signal);
corrsHG_allsub(subject,:) = xcov_signals(hr_signal,global_signal);

end

%save 
    
% network labels
network_labels = {'ddmn-vdmn', 'ddmn-sal', 'ddmn-lcen', 'ddmn-rcen', ...
                  'vdmn-sal', 'vdmn-lcen', 'vdmn-rcen',  ...
                  'lcen-sal', 'lcen-rcen', ...
                  'rcen-sal'};
    
% write spreadsheets of output 
% each is a CSV file of 543 subjects x 10 network pairs
% write_output_sheet('regressed_A.csv', network_labels, regA_allsub, subject_IDs);
% write_output_sheet('regressed_G.csv', network_labels, regG_allsub, subject_IDs);
% write_output_sheet('regressed_H.csv', network_labels, regH_allsub, subject_IDs);
% write_output_sheet('regressed_All.csv', network_labels, regAll_allsub, subject_IDs);
% write_output_sheet('regressed_AG.csv', network_labels, regAG_allsub, subject_IDs);
% write_output_sheet('non_regressed.csv', network_labels, noreg_allsub, subject_IDs);

write_output_sheet('regressed_A_last2.csv', network_labels, regA_allsub, subject_IDs);
write_output_sheet('regressed_G_last2.csv', network_labels, regG_allsub, subject_IDs);
write_output_sheet('regressed_H_last2.csv', network_labels, regH_allsub, subject_IDs);
write_output_sheet('regressed_All_last2.csv', network_labels, regAll_allsub, subject_IDs);
write_output_sheet('regressed_AG_last2.csv', network_labels, regAG_allsub, subject_IDs);
write_output_sheet('non_regressed_last2.csv', network_labels, noreg_allsub, subject_IDs);

% write mat files of global signal outputs
S =[corrsG_allsub, corrsA_allsub, corrsH_allsub];
Name=['G_ddmn', 'G_vdmn', 'G_sal', ...
                  'G_rcel', 'G_lcen', ...
                  "A_ddmn",'A_vdmn', 'A_sal', ...
                  'A_rcen', 'A_lcen', ...
                  "H_ddmn", 'H_vdmn', 'H_sal',...
                  'H_rcen', 'H_lcen',]

T_GN= array2table(S,'VariableNames',Name)
T_path=[save_path,'/','Networks_Corr_Global_Components_last2.csv']
writetable(T_GN,T_path)

S_2=[corrsAG_allsub, corrsHA_allsub,corrsHG_allsub];
Name_2=["corrAG","corrHA","corrHG"]

T_GG= array2table(S_2,'VariableNames',Name_2)

T_path2=[save_path,'/','GlobalComponents_Corr_GlobalComponents_last2.csv']
writetable(T_GG,T_path2)









    
    
