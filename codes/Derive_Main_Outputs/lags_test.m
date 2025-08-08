%This code will regress 3 TR (6.3 sec) lags of global components

%Author: Kim Kundert-Obando for questions please reach out to me at k.rogge.obando@gmail.com

%%
%load subjects and paths
subj= readtable('/data1/neurdylab/datasets/nki_rockland/vigilance_analysis/great_HR_sub_coded.txt', 'readvariablenames', 0);
save_path = '/data1/neurdylab/datasets/nki_rockland/vigilance_analysis/subject_outputs';

% set up matrices that will store data for all subjects

regA_allsub_lags = [];
regG_allsub_lags = [];


subject_IDs = {};
%%
for subject = 1:height(subj)
    %%
    this_subject = subj{subject,1}{1}
    subject_IDs{subject} = this_subject;
    %load network ts

    regression_analysis_filename=[save_path,'/',this_subject,'_regression_analysis_out.mat']

    load(regression_analysis_filename);

    network_signals=orig_tc;
    %%
    %load global components tc

    arousal_filename = [save_path, '/', this_subject,'_arousal_tc.mat'];

    load(arousal_filename);

    global_signal_filename = [save_path,'/',this_subject,'_global_signal_tc.mat'];

    load(global_signal_filename);

    % time courses of interest
    global_signal= global_signal_tc';
    arousal_signal=arousal_tc;

    global_signal=zscore(global_signal);
    arousal_signal=zscore(arousal_signal);

    %run function that makes a model with lags for fMRI
    lag=3;
    [arousal_signal_lags_f,arousal_signal_lags_b]=generate_fmri_lags(arousal_signal,lag);
    [global_signal_lags_f,global_signal_lags_b]=generate_fmri_lags(global_signal,lag);

    %add lags with original signal
    %%
    arousal_signal_lags_model=[arousal_signal,arousal_signal_lags_b',arousal_signal_lags_f'];
    global_signal_lags_model=[global_signal,global_signal_lags_b',global_signal_lags_f'];
    %plot(arousal_signal_lags_b(1,:))
    %hold on
    %plot(arousal_signal_lags_b(2,:))
    %%
    %run regressor function
    [regressed_A_with_lag_tc, regressed_A_with_lag_fc] = regress_tc_non_zscored(network_signals, arousal_signal_lags_model);
    [regressed_G_with_lag_tc, regressed_G_with_lag_fc] = regress_tc_non_zscored(network_signals, global_signal_lags_model);

    %%


    % store the data for this subject
    regression_analysis_filename=[save_path,'/',this_subject,'_regression_analysis_with_lag_out.mat']
    save(regression_analysis_filename, ...
        'regressed_A_with_lag_tc', 'regressed_A_with_lag_fc', ...
        'regressed_G_with_lag_tc', 'regressed_G_with_lag_fc');

    % store flattened values for this subject
    regA_allsub(subject,:) = retrieve_fc_values(regressed_A_fc);
    regG_allsub(subject,:) = retrieve_fc_values(regressed_G_fc);

end
%%
% network labels
network_labels = {'ddmn-vdmn', 'ddmn-sal', 'ddmn-lcen', 'ddmn-rcen', ...
    'vdmn-sal', 'vdmn-lcen', 'vdmn-rcen',  ...
    'lcen-sal', 'lcen-rcen', ...
    'rcen-sal'};

% write spreadsheets of output
% each is a CSV file of 543 subjects x 10 network pairs
%%
write_output_sheet('regressed_A_with_lag.csv', network_labels, regA_allsub, subject_IDs);
write_output_sheet('regressed_G_with_lag.csv', network_labels, regG_allsub, subject_IDs);
%%
