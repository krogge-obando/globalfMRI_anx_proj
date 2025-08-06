function [regressed_tc, regressed_fc] = regress_tc(network_signals, regressor_signals)

X = appendOnes(regressor_signals);
B = pinv(X)*network_signals;
yhat_tc = X*B;
regressed_tc = network_signals - yhat_tc;
regressec_fc = corr(regressed_tc);