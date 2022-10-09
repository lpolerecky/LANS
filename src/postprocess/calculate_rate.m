function a_new = calculate_rate(a, bkg, medium, dt, data_tmnt, k, var_name, fname)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate rate from enrichment (added 20-02-2019):
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is used to calculate rate constants from the enrichment data. The
% calculation is based on 1st-order kinetics of substrate uptake, i.e.,
% dS/dt = k*S, where S is the isotopically labeled substrate. If we denote
% the atom fraction in the substrate (=medium) as X(medium), the atom
% fraction in the cell as X(cell), and the atom fraction in the reference
% to which both the medium and cell are compared as X(ref) (e.g., this
% value is, preferably, the value of X(cell) at time-point 0), then we
% calculate the excess atom fractions (aka enrichment) as
% XE(cell) = X(cell) - X(ref),
% XE(medium) = X(medium) - X(ref).
% Using the above assumption of 1st-order kinetics, the relationship
% between XE(cell) and XE(medium) after incubation time dt is 
% XE(cell) = XE(medium) * (1-exp(-k*dt)).
% From this the rate constant is calculated as
% k = -(1/dt)*ln(1-XE(cell)/XE(medium)).
% If the standard error of X(cell) is denoted as dX(cell), then the
% standard error of the k is calculated as
% dk = 1/dt * dX(cell)/(X(medium-X(cell)).
% Note that in the last equation X are used (not XE!).
%
% Example: Let's assume we are interested in the rate of C uptake derived
% from the measurements of 13C and 12C. We define the variable
% X1=13C/(12C+13C), which corresponds to 13C atom fraction, X. Let's also
% assume that we have performed measurements for 2 treatments:
% Treatment 1: medium X(13C) = 0.5, incubation time 2 hrs
% Treatment 2: medium X(13C) = 0.8, incubation time 6 hrs
% Last, let's assume that the reference value is X(ref)=0.0106.
% Then, in the Correction & Calculation settings GUI, we enter in the
% "Fixed average" field for X1 the value of 0.0106, in the "Medium value"
% field we enter values 0.5 0.8 (in this order), in the "Treatments" field
% we enter values 1 2 (in this order), and in the "Incubation times" we
% enter values 2 6 (in this order). 
% Finally, we check the X1 checkbox in the "Rate calculation settings" area
% and press "Apply". When choosing "Export and display data in ROIs" or
% "Compare classes and Treatments" in the "Process multiple datasets from
% metafile" GUI, the exported/displayed/compared data will be the rate
% constants k instead of the ratios 13C/(12C+13C). If you want to quickly
% go back and work with the ratio data, simply uncheck the X1 checkbox in
% the "Rate calculation settings" and click "Apply".
% NOTE: to additionally apply the corrections (e.g. for a possible bkg
% drift; see make_data_correction.m), check also the X1 checkbox in the
% "Correction settings" area.

a_new=a;

for cci=1:length(a) 
    val = a{cci};  % val is now a matrix with rows [X dX] in ROIs
    % bkg is X in the reference (e.g., ROIs at t=0)
    % medium is X in the medium
    % dt is the incubation time
    if ~isempty(val)
        % excess atom fraction:
        % XE(i) = X(i)-X(standard)                                
        % rate constant based on first-order kinetics:
        % k = -(1/dt)*ln(1-XE(cell)/XE(medium))
        % dk = 1/dt * dX(cell)/(X(medium-X(cell))
        t1 = 1 - (val(:,1)-bkg) / (medium-bkg);
        rate = zeros(size(val(:,1)));
        rate(t1>0) = -(1/dt) * log(t1(t1>0));
        rate(t1<=0) = nan;
        d_rate = (1/dt) * val(:,2)./abs(medium-val(:,1));
        a_new{cci} = [rate d_rate];
    end
end
% make sure that this calculation is announced to the user!
fprintf(1,'Rate calculated for variable %d (%s): tmnt=%d, bkg=%.5f, medium=%.4f, dt=%.2f (%s)\n',k,var_name,data_tmnt,bkg,medium,dt,fname);
