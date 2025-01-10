function shift_columns_rows = get_shift_columns_rows(shift_columns_rows)
%shift_columns_rows = [0 0 0 0];

% new approach (17-02-2024) allows shifting more than one column or row
dlg_title = 'Shift edge columns and rows';
prompt = {'Number of left-most columns to shift to the right-most position (0,1,...):', ...
          'Number of right-most columns to shift to the left-most position (0,1,...):', ...
          'Number of top-most rows to shift to the lower-most position (0,1,...):', ...
          'Number of lower-most rows to shift to the top-most position (0,1,...):'};
num_lines = 1;
def = {num2str(shift_columns_rows(1)), ...
       num2str(shift_columns_rows(2)), ...        
       num2str(shift_columns_rows(3)), ...
       num2str(shift_columns_rows(4))};
answer  = inputdlg(prompt, dlg_title, num_lines, def);

if ~isempty(answer)
    shift_columns_rows = [str2num(answer{1}), str2num(answer{2}), ...
                          str2num(answer{3}), str2num(answer{4})];   
end

% OBSOLETE
% code before 17-02-2024 allowed shifting only one column or row
if 0
    
%function shift_columns_rows = get_shift_columns_rows(handles)
%shift_columns_rows = [0 0 0 0];
if isfield(handles,'shift_last_row_beginning')
    if strcmp(get(handles.shift_last_row_beginning,'checked'),'on')
        shift_columns_rows(1) = 1;
    end
end
    
if isfield(handles,'shift_first_row_end')
    if strcmp(get(handles.shift_first_row_end,'checked'),'on')
        shift_columns_rows(2) = 1;
    end
end

if isfield(handles,'shift_last_column_beginning')
    if strcmp(get(handles.shift_last_column_beginning,'checked'),'on')
        shift_columns_rows(3) = 1;
    end
end

if isfield(handles,'shift_first_column_end')
    if strcmp(get(handles.shift_first_column_end,'checked'),'on')
        shift_columns_rows(4) = 1;
    end
end

end