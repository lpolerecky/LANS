function handles = shift_columns_rows(handles, shift_columns_rows)

% LP: for some unknown reason in some files the first or last columns or rows in the
% images are shifted as last or first one. Use this function to make sure that the
% columns are sorted properly immediately after the import of the data
% added 05-Sep-2017

if nargin==1
    % find shifting flags from the GUI
    shift_columns_rows = get_shift_columns_rows(handles);
end;

% shift image columns and rows depending on the flags
handles.p.im = shift_columns_rows_images(handles.p.im, shift_columns_rows);

% add the flags to the properties of the dataset
handles.p.shift_columns_rows = shift_columns_rows;
