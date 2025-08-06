function xcov_values = xcov_signals(input_signal1, ...
                                           input_signal2)

% assumes network signals are in each *column*
xcov_values = [];
for ii=1:size(input_signal2,2)
   [c,lags] = xcov(input_signal1, input_signal2(:,ii), 10, 'coeff');
   xcov_values(ii) = max(c);
end

