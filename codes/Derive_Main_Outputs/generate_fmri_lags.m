%Author: Kim Kundert-Obando for questions please reach out to me at k.rogge.obando@gmail.com
function [front_time_course_lagged_stored, back_time_course_lagged_stored]=generate_fmri_lags(time_course,lag)

for conduct_lag= 1:lag

    dims=size(time_course);
    lags=dims(1)-conduct_lag;

    time_course_lagged_forward_step=time_course(1:lags,:);
    time_course_lagged_backward_step=time_course(conduct_lag+1:end,:);
    
    zero_fill_in=zeros(conduct_lag,1);

    front_time_course_lagged=[zero_fill_in;time_course_lagged_forward_step];
    back_time_course_lagged=[time_course_lagged_backward_step;zero_fill_in];
    
    front_time_course_lagged_stored(conduct_lag,:)=[front_time_course_lagged];
    back_time_course_lagged_stored(conduct_lag,:)=[back_time_course_lagged];
    
end
end
