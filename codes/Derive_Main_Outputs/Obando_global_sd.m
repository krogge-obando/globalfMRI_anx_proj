%This code will generate a csv file with the global component gs_sd or estimated_drowsiness value of
%the 543 subjects

%Load subject list

subj= readtable('/data1/neurdylab/datasets/nki_rockland/vigilance_analysis/great_HR_sub_coded.txt', 'readvariablenames', 0);

subject_IDs = {};
for subject=1:height(subj)

    this_subject = subj{subject,1}{1}
    subject_IDs{subject} = this_subject;

    subj_gs_ts = ['/data1/neurdylab/datasets/nki_rockland/vigilance_analysis/subject_outputs/',this_subject,'_global_signal_tc.mat'];
    subj_a_ts =  [ '/data1/neurdylab/datasets/nki_rockland/vigilance_analysis/subject_outputs/', this_subject,'_arousal_tc.mat']']
    
    load(subj_gs_ts)
    load(subj_a_ts)

    gs_sd=std(global_signal_tc);
    estimated_drowsiness=std(arousal_tc);

    subj_gs_sd(subject,:)=[gs_sd];
    subj_ed_sd(subject,:)=[estimated_drowsiness];

end

file=table(subject_IDs',subj_gs_sd,subj_ed_sd);
file = renamevars(file,["Var1","subj_gs_sd","subj_ed_sd"], ...
                 ["ID","GS_sd","estimated_drowsiness"]);

writetable(file,"543_gs_ed.csv")
