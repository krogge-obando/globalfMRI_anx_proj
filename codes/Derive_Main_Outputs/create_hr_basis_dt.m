function X_physio = create_hr_basis_dt(hr,TR)
% create physiological basis set, based on the time and
% dispersion derivatives of each gamma in the RRF, and each gamma
% in the CRF.
% as in Chen et al. NI 2020
% This function will be called. Just keep it saved. 


% time axis
dt = TR;
t = [0:dt:40]; % assume 40-s long
v1 = ones(size(rv,1),1);
t0 = [1:size(rv,1)];
v2 = t0';
v3 = t0.^2';
v4 = t0.^3';
v5 = t0.^4';
%size(v1)
%size(v2)
%size(v3)
%size(v4)
%size(v5)
X_dt = [v1 v2 v3 v4 v5];
%size(X_dt)

%% RRF basis:
% original, temporal derivatives, dispersion derivatives
rrf_p = 0.6*t.^(2.1).*exp(-t/1.6) - 0.0023*t.^(3.54).*exp(-t/4.25);
rrf_t1 = -0.79*t.^(2.1).*exp(-t/1.6) + 2.66*t.^(1.1).*exp(-t/1.6);
rrf_t2 = -0.069*t.^(2.54).*exp(-t/4.25) + 0.0046*t.^(3.54).*exp(-t/4.25);
rrf_d1 = 0.16.*t.^(3.1).*exp(-t./1.6);
rrf_d2 = 0.00014.*t.^(4.54).*exp(-t./4.25);


%% CRF basis:
crf_p = 0.3*t.^(2.7).*exp(-t/1.6) - 1.05*exp(-((t-12).^2)/18);
crf_t1 = 1.94*t.^(1.7).*exp(-t/1.6) - 0.45*t.^(2.7).*exp(-t/1.6);
crf_t2 = 0.55*(t-12).*exp(-((t-12).^2)/18);
crf_d1 = 0.056*t.^3.7.*exp(-t/1.6);
crf_d2 = 0.15*((t-12).^2).*exp(-((t-12).^2)/18);


%% convolve RV with RRF basis:
% %RV = rv-mean(rv); % zero mean before conv
% RV_wt = rv;
% RV_wt = RV_wt(:); % enforce column vector
% %size(RV_wt)
% B_RV = pinv(X_dt)*RV_wt;
% RV_t = X_dt*B_RV;
% RV = RV_wt-RV_t;
% 
% RV_conv = [];
% RV_conv(:,1) = conv(RV,rrf_p);
% RV_conv(:,2) = conv(RV,rrf_t1);
% RV_conv(:,3) = conv(RV,rrf_t2);
% RV_conv(:,4) = conv(RV,rrf_d1);
% RV_conv(:,5) = conv(RV,rrf_d2);
% RV_basis_regs = RV_conv(1:length(RV),:); 


%% convolve HR with CRF basis:
%HR = hr-mean(hr); % zero mean before conv
HR_wt = hr;
HR_wt = HR_wt(:); % enforce column vector
B_HR = pinv(X_dt)*HR_wt;
HR_t = X_dt*B_HR;
HR = HR_wt-HR_t;

HR_conv = [];
HR = HR(:); % enforce column vector
HR_conv(:,1) = conv(HR,crf_p);
HR_conv(:,2) = conv(HR,crf_t1);
HR_conv(:,3) = conv(HR,crf_t2);
HR_conv(:,4) = conv(HR,crf_d1);
HR_conv(:,5) = conv(HR,crf_d2); 
HR_basis_regs = HR_conv(1:length(HR),:); 


%% return HR
X_physio = [HR_basis_regs];
