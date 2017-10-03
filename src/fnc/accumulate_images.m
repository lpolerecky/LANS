function [accu_images, im]=accumulate_images(im,xyalign,find_alignments,mass,all_images, opt)
% Return accummulated images for each mass as well as aligned images. To
% save memory, the input array IM is aligned and passed as output.

accu_images=[];

nmasses = length(im);

% fix the options and all_images if more than 7 masses have been detected
if length(opt)<nmasses
    opt = [opt ones(1,nmasses-length(opt))];
end;
if length(all_images)<nmasses
    ai{1}=all_images;
    for ii=1:(nmasses-length(all_images))
        ai{length(ai)+1} = ai{1};
    end;
    all_images=ai;
end;

if(nargin>5)
    oo=opt;
else
    oo=ones(1,nmasses);
end;

% align images first, if requested
if find_alignments & size(im{1},3)>1 & ~isempty(xyalign)   
    
    disp('Aligning images:');
    
    for ii=1:nmasses
        images = all_images{ii};
        
        % if images is empty, align all images
        if isempty(images)
            images=[1:size(im{ii},3)];
        end;
        
        s=[mass{ii},': '];
        
        for jj=1:length(images)
            
            if oo(ii)
                
                s=[s num2str(images(jj)) ' '];
                
                % this is where the actual alignment happens
                tmpi=[];
                tmpi(:,:) = im{ii}(:,:,images(jj));
                se=translate(strel(1),[xyalign(images(jj),1) xyalign(images(jj),2)]);
                tmpi=imdilate(tmpi,se);
                ind=find(tmpi<0);
                tmpi(ind)=zeros(size(ind));                
                im{ii}(:,:,images(jj))=tmpi; % im is now aligned
                
            else
                
                if(jj==length(images))
                    s=[s, 'Mass not aligned during accumulation. Check the corresponding box to force alignment.'];
                end;
                
            end;

        end;
        
        disp(s);

    end;
    
end;

fprintf(1,'Accummulating masses (image range)\n');
% accumulate the aligned images
for ii=1:nmasses
    images = all_images{ii};

    if iscell(images)
        images=cell2mat(images);
    end;
    
    % if images is empty, align all images
    if isempty(images)
        images=[1:size(im{ii},3)];
    end;

    % do the final accumulation
    tmpi=[];
    tmpi=im{ii}(:,:,images);
    accu_images{ii}=sum(tmpi,3);
    
    % write progress
    if ii<nmasses
        fprintf(1,'%s (%d:%d), ',mass{ii},min(images),max(images));
    else
        fprintf(1,'%s (%d:%d)\n',mass{ii},min(images),max(images));
    end;
    
end;

fprintf(1,'Done.\n');
