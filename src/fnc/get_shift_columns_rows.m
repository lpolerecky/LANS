function shift_columns_rows = get_shift_columns_rows(handles)
shift_columns_rows = [0 0 0 0];

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
