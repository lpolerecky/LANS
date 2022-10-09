function [accu_images, im, error_occurred]=accumulate_images2(im,tforms,mass,all_images, opt)
% Return accummulated images for each mass as well as aligned images. To
% save memory, the input array IM is aligned and passed as output.

accu_images=[];

nmasses = length(im);

% LP: (27-08-2018)
% make sure that im is type double, to avoid loosing data due to
% conversion to uint16!!!
for ii=1:nmasses
    im{ii} = double(im{ii});
end

% fix the options and all_images if more than 7 masses have been detected
if length(opt)<nmasses
    opt = [opt ones(1,nmasses-length(opt))];
end
if length(all_images)<nmasses
    if length(all_images)==1
        ai{1}=all_images{1};
        for ii=1:(nmasses-length(all_images))
            ai{length(ai)+1} = ai{1};
        end
        all_images=ai;
    else
        ai = all_images;
        for ii=(length(all_images)+1):nmasses
            ai{ii} = all_images{1};
        end
        all_images=ai;
    end        
end

if(nargin>5)
    oo=opt;
else
    oo=ones(1,nmasses);
end

% align images first, if requested
t1=clock;
    
error_occurred = 0;

%if find_alignments 
%    
%    if size(im{1},3)>1 && ~isempty(tforms)
if ~isempty(tforms)
    if length(tforms)<size(im{1},3)
        %% mismatch error
        opts = struct('WindowStyle','modal', 'Interpreter','none');
        tit = {'Length of alignment tforms does not match number of planes.',...
            'Remove xyalign.mat (see Preferences menu) and realign images.'};
        edl = errordlg(tit,'Error',opts);
        error_occurred = 0;
        fprintf(1,'Error occurred. Images not aligned.\n');
    else        
        %% align images
        disp('Aligning images based on tforms (method implemented on 04-06-2018):');        
        for ii=1:nmasses
            images = all_images{ii};
            % if images is empty, align all images
            if isempty(images)
                images=[1:size(im{ii},3)];
            end
            s=[mass{ii},': '];
            fixed2 = squeeze(im{ii}(:,:,images(1)));
            for jj=1:length(images)
                if oo(ii)
                    s=[s num2str(images(jj)) ' '];
                    %% this is where the actual alignment happens
                    indj = images(jj);
                    moving2 = squeeze(im{ii}(:,:,indj));                                
                    movingRegistered2 = imwarp(moving2,tforms{indj},...
                        'OutputView',imref2d(size(fixed2)),...
                        'Interp','linear');                                    
                    im{ii}(:,:,indj)=movingRegistered2; % im{ii} is now aligned
                else
                    if(jj==length(images))
                        s=[s, 'Mass not aligned during accumulation. Check the corresponding box to force alignment.'];
                    end
                end
            end
            disp(s);
        end
    end    
end

if ~error_occurred
    fprintf(1,'Accumulating mass (image range)\n');
    accu_images=cell(1,nmasses);
    %% accumulate the aligned images for each mass
    for ii=1:nmasses
        images = all_images{ii};
        if iscell(images)
            images=cell2mat(images);
        end
        % if images is empty, accumulate all images
        if isempty(images)
            images=[1:size(im{ii},3)];
        end
        %% this is where the accumulation happens       
        accu_images{ii}=sum( im{ii}(:,:,images), 3);
        % write progress
        if ii<nmasses
            fprintf(1,'%s (%d:%d), ',mass{ii},min(images),max(images));
        else
            fprintf(1,'%s (%d:%d)\n',mass{ii},min(images),max(images));
        end
    end
    t2=clock;
        fprintf(1,'Alignment of all masses and planes done in %.3fs\n',etime(t2,t1));
    end
end

%fprintf(1,'Done.\n');
