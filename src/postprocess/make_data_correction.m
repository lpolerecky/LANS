function a_new = make_data_correction(a, cls, corr_class, corr_value, k, var_name)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply corrections (added 16-10-2018):
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is used to correct for a possible drift in the bkg
% value.
% Example: Let's assume we are interested in variable X1=13C/(12C+13C) 
% and we want to ensure that the value of X1 in bkg ROIs is
% equal to 0.0106 for all datasets. To do this, first we
% need to define bkg ROIs in all datasets in a metafile and
% classify them as 'x', where 'x' stands for the bkg class.
% Second, in the Correction & Calculation Settings, we
% define the "class with fixed value" as 'x', "fixed
% average" as 0.0106, check the X1 checkbox, and click
% "Apply". 
% When calculating the values of X1 in a given dataset, the
% ROIs of class 'x' are found, and a corection factor is
% found such that the mean value of X1 in ROIs of class
% 'x' is equal to 0.0106. Subsequently, the values of X1 in
% *all* ROIs are multiplied by this correction factor. This
% is done for each dataset from the metafile. If there are
% no ROIs 'x' in a dataset, the correction factor is set to
% 1, i.e., no correction is applied.
% NOTE: to make this correction active, you must not only check the
% "Apply corr. to variable" checkbox in the Correction & Calculation
% settings, but also *include* the class 'x' in the "Included classes"
% field in the "Process multiple datasets from metafile" GUI.

a_new = a;

% first find the correction factor
corr_factor = 1;
for cci=1:length(cls)
    if ~isempty(cls{cci})
        cc = char(cls{cci}(1));
        if cc==corr_class
            cc_mean = mean(a{cci}(:,1));
            corr_factor = corr_value/cc_mean;
        end
    end
end
% now apply the correction factor to all data
for cci=1:length(a)
    a_new{cci} = corr_factor * a{cci};
end
% make sure that this correction is announced to the user!
fprintf(1,'Correction applied for variable %d (%s) (factor=%.4e)\n',k,var_name,corr_factor);
