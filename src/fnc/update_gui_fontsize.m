function h=update_gui_fontsize(h)

global GUI_FONTSIZE;

%% scribeOverlay is causing errors, so I remove it, as recommended in
% https://nl.mathworks.com/matlabcentral/answers/482510-annotationpane-handle-appearing-in-guide-guis-with-panel-axes-in-r2019b
% Check if scribeOverlay is a field and that it contains an annotation pane
if isfield(h,'scribeOverlay') && isa(h.scribeOverlay(1),'matlab.graphics.shape.internal.AnnotationPane')
    delete(h.scribeOverlay);
    h = rmfield(h, 'scribeOverlay');
end

display_message(sprintf('Changing fontsize of all uicontrols in the GUI to %d ... ',GUI_FONTSIZE));

% this was the "old" way, a more efficient approach is below
if 0
f = fieldnames(h);
for i=1:length(f)
    fld = f{i};
    s = ['hnd = h.' fld ';'];
    eval(s);
    % debug
    %fprintf(1,'%s\n', s);
    if ~iscell(hnd) && ~isnumeric(hnd) && ~istable(hnd) && ~ischar(hnd)
        if prod(isprop(hnd,'Type')) && length(hnd)<2
            s = ['htype = h.' fld , '.Type;'];
            eval(s)
            if strcmp(htype,'uicontrol') || strcmp(htype,'uipanel')
                s = ['h.' fld '.FontSize = GUI_FONTSIZE;'];
                eval(s);
            end
        end
    end
end
end

% this is the improved version (from 2026)
allUIObjects = findobj(h.figure1, '-property', 'FontSize');
for k = 1:numel(allUIObjects)
    allUIObjects(k).FontSize = GUI_FONTSIZE;
end

display_message('Done.\n');
display_message('Note: you can adjust GUI_FONTSIZE in lans_paths.m to optimize it for your computer.\n')
