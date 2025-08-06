function flattened_values = retrieve_fc_values(fc_matrix)
% retrieve specific entries of FC matrix for Kim's NKI project
% April 19, 2024

d_dmn_index = 1;
v_dmn_index = 2;
sal_index   = 3;
lcen_inedx  = 4;
rcen_index  = 5;

flattened_values(1) = fc_matrix(d_dmn_index, v_dmn_index);
flattened_values(2) = fc_matrix(d_dmn_index, sal_index);
flattened_values(3) = fc_matrix(d_dmn_index, lcen_index);
flattened_values(4) = fc_matrix(d_dmn_index, rcen_index);
flattened_values(5) = fc_matrix(v_dmn_index, sal_index);
flattened_values(6) = fc_matrix(v_dmn_index, lcen_index);
flattened_values(7) = fc_matrix(v_dmn_index, rcen_index);
flattened_values(8) = fc_matrix(lcen_index, sal_index);
flattened_values(9) = fc_matrix(lcen_index, rcen_index);
flattened_values(10) = fc_matrix(rcen_index, sal_index);