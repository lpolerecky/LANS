function [dc, pp, p] = read_imp_file(filename)

% Read the binary imp file produced by the NanoSIMS 1280 machine, and output
% the raw images as well as the additional parameters characterizing the
% dataset.
% L.P. 05-10-2026

    % 1. Open the file in read-only binary mode
    fprintf(1,'Reading file %s ...', filename);
    fileID = fopen(filename, 'r', 'b'); 
    if fileID == -1
        error('Could not open file %s. Please check the path.', filename);
    end

    try

        % 2. Read the last 2^16 bytes into memory as a byte array, 
        % this section of the file should contain the header.
        numBytes = 2^16;
        fseek(fileID, -numBytes, 'eof');
        rawBytes = fread(fileID, numBytes, 'uint8')';
        fclose(fileID);
        
        % 3. Convert bytes to character string for processing
        % Replace null characters with spaces to preserve length and readability
        headerText = char(rawBytes);
        headerText(rawBytes == 0) = ' ';

        % 4. search for patterns to extract properties of the acqusition

        % 4a. raster size
        rasterSizeValue = seek_pattern(headerText, ...
            '<d_RasterSize[^>]*>(.*?)</d_RasterSize>', ...
            'once', 'Raster size', 'um');

        % 4b. analysis time
        TotalAnalysisTime = seek_pattern(headerText, ...
            '<d_TotalAnalysisTime[^>]*>(.*?)</d_TotalAnalysisTime>', ...
            'once', 'Total Analysis Time', 's');

        % 4c. number of cycles (planes)
        AcquiredCycleNb = seek_pattern(headerText, ...
            '<n_AcquiredCycleNb_RW[^>]*>(.*?)</n_AcquiredCycleNb_RW>', ...
            'once', 'Acquired Cycles', []);
        fprintf('\nTotal number of detected planes: %d\n', AcquiredCycleNb);

        % 4d. image width and height
        ImageWidth = seek_pattern(headerText, ...
            '<m_nSize[^>]*>(.*?)</m_nSize>', ...
            'once', 'Image Width', 'pix');
        ImageHeight = ImageWidth;
        fprintf('Size of the images: %d x %d pix\n', ImageHeight, ImageWidth);

        % 4e. acquisition date and time
        DateTime = seek_pattern(headerText, ...
            '<psz_Date[^>]*>(.*?)</psz_Date>', ...
            'once', 'Date & Time', [], 1);
        parts = split(DateTime, ' ');
        dateStr = parts{1};
        timeStr = parts{2};

        % 4f. absolute position of the sample
        sple_pos_x = seek_pattern(headerText, ...
            '<d_PX[^>]*>(.*?)</d_PX>', ...
            'once', 'X position', 'um');
        sple_pos_y = seek_pattern(headerText, ...
            '<d_PY[^>]*>(.*?)</d_PY>', ...
            'once', 'Y position', 'um');

        % 4g. masses of measured ions
        pattern = '<d_Mass [^>]*>(.*?)</d_Mass>';
        [~, tokens] = regexp(headerText, pattern, 'match', 'tokens');
        if ~isempty(tokens)
            fprintf(1,'Total number of detected masses: %d\n', length(tokens));
            mass = zeros(1,length(tokens));
            for i=1:length(tokens)
                mass(i) = str2double(tokens{i});
                %fprintf('Detected mass %d: %g amu\n', i, mass{i});
            end
        else
            mass = [];
            warning('Info about Detected masses not found.');
        end

        %4h. mass names
        pattern = '<psz_MatrixSpecies[^>]*>(.*?)</psz_MatrixSpecies>';
        [~, tokens] = regexp(headerText, pattern, 'match', 'tokens');
        if ~isempty(tokens)
            mass_name = cell(1,length(tokens));
            for i=1:length(tokens)
                mass_name{i} = tokens{i}{1};
                mass_name{i} = regexprep(mass_name{i}, '\s', '');
                %fprintf('Detected mass %d: %s\n', i, mass_name{i});
            end
        else
            mass_name = [];
            warning('Info about Detected mass names not found.');
        end

        %%% READ THE BINARY COUNTS DATA and convert it into dataCube based
        %%% on the information determined above
        if ~isempty(ImageWidth) & ~isempty(ImageHeight) & ...
                ~isempty(AcquiredCycleNb) & ...
                ~isempty(mass_name)
            fprintf(1,'Loading planes (out of %d)\n', AcquiredCycleNb);
            % open the file
            fileID = fopen(filename, 'r', 'b');
            % testing suggests that the raw data starts on byte 23
            fseek(fileID, 23, 'bof');
            numBytes = ImageWidth * ImageHeight * AcquiredCycleNb * length(mass_name);
            % load raw data
            rawBytes = fread(fileID, numBytes, 'uint16')';
            % close the file again
            fclose(fileID);
            % convert it to a data cube
            dc = convert_data2dataCube(rawBytes, ImageHeight, ImageWidth, ...
                AcquiredCycleNb, length(mass_name));

            % DISPLAY the data cube (only for debugging)
            % display_dataCube(dc);

            % organize the output in the same way as that produced by
            % read_im_file.m, which is the "original" format developed for
            % the NanoSIMS 50L data
            [pathstr, name, ~] = fileparts(filename);
            p.filename = [pathstr delimiter name];
            p.reverse_bytes = 0; % no idea whether this is present in IMP files
            p.pos = [sple_pos_x sple_pos_y 0];
            p.mass = mass_name;
            p.mass_precise = mass;
            p.date = dateStr;
            p.time = timeStr;
            p.width = ImageWidth;
            p.height = ImageHeight;
            p.scale = rasterSizeValue;
            pp = 1:AcquiredCycleNb;
            % calculate also dwell time, estimated from the analysis duration
            dwell_time_factor = 1; % no idea whether this is available in IMP files
            p.dwell_time = round(TotalAnalysisTime/AcquiredCycleNb/ImageWidth/ImageHeight*1e3/dwell_time_factor*1e3)/1e3; % in msec
            fprintf(1,'Dwell time estimated from analysis duration, image size and cycle number: %g ms\n',p.dwell_time);            
        end

    catch ME
        rethrow(ME);
    end

    % left here for debugging
    %a=0;

end

function out = seek_pattern(hdr, pattern, how_many_times, PropName, PropUnit, as_string)
% seek lines in the header string for a pattern to find parameters during
% the measurements
    [~, tokens] = regexp(hdr, pattern, 'match', 'tokens', how_many_times);
    if ~isempty(tokens)
        if nargin>5
            as_str = as_string;
        else
            as_str = 0;
        end
        if as_str
            out = tokens{1};
            %fprintf('%s = %s %s\n', PropName, out, PropUnit);
        else
            out = str2double(tokens{1});
            %fprintf('%s = %g %s\n', PropName, out, PropUnit);
        end            
    else
        warning('Info about %s not found.', PropName);
        out=[];
    end
end

function dataCube = convert_data2dataCube(rawData, pixelHeight, pixelWidth, nLayers, nMasses)
% convert the rawData into a set of images for each mass and plane
    WH = pixelWidth * pixelHeight;
    dataCube = cell(nMasses,1);
    for m = 1:nMasses
        dataCube{m} = zeros(pixelHeight, pixelWidth, nLayers);
    end
    for k = 1:nLayers
        for m = 1:nMasses    
            startIdx = (m-1)*WH + (k-1)*WH*nMasses + 1;
            endIdx   = m*WH     + (k-1)*WH*nMasses;
            if endIdx <= length(rawData)
                layerMatrix = reshape(rawData(startIdx:endIdx), [pixelWidth, pixelHeight])';
                dataCube{m}(:,:,k) = layerMatrix;
            end
        end
        fprintf(1,'%3d ',k);
    end
    fprintf(1,'\nDone.\n');
end

function fig = display_dataCube(dataCube)
% this function is used during debugging to check whether raw data is
% read correctly - by visual comparison of the images with those produced
% by WinImage
    fig = figure(101);
    nm = length(dataCube);
    np = size(dataCube{1},3);
    k=0;
    for j=1:nm
        for i=1:np
            k = k+1;
            a = dataCube{j}(:,:,i);
            subplot(nm, np, k);
            switch j
                % these are hard-coded for testing
                case 1, imsc = [0 51];
                case 2, imsc = [0 25];
                otherwise, imsc = [0 4];
            end
            if 1
                a = log10(a);
                imagesc(a, [-1 log10(imsc(2))]);
            else
                imagesc(a, imsc);
            end
            colorbar;
            title(sprintf("m=%d, p=%d", j, i))
        end
        figure(fig);
        pause(0.2);
    end
    colormap(clut);            
end