function [tform, imlist, xyalign, f40, choice] = findimagealignments2(im,images,x_special,y_special, ask_for_confirmation)
% Find alignment tforms
% 04.06.2018, Lubos Polerecky 

if nargin<5
    ask_for_confirmation = 1;
end

% show images for debugging
be_verbous = 0;

if ask_for_confirmation
    fprintf(1,'*** This is findimagealignments2 ***\n');
end

% crop special region only
if nargin>3 && ~isempty(x_special) && ~isempty(y_special)
    xreg=x_special;
    yreg=y_special;        
else
    xreg=1:size(im,2);
    yreg=1:size(im,1);
end

xreg=sort(xreg);
yreg=sort(yreg);
if min(xreg)<1
    xreg = [1:xreg(2)];
end
if max(xreg)>size(im,2)
    xreg = [xreg(1):size(im,2)];
end
if min(yreg)<1
    yreg = [1:yreg(2)];
end
if max(yreg)>size(im,1)
    yreg = [yreg(1):size(im,1)];
end

all_images = [1:size(im,3)];
% default output = no transform
for i=1:length(all_images)
    tform{i}=affine2d([1 0 0; 0 1 0; 0 0 1]);
end
xyalign=zeros(length(all_images),2);
movingRegistered2 = zeros(size(im,1),size(im,2),length(all_images));

% align all images in case IMAGES is empty
if isempty(images)
    imlist = all_images;
else
    imlist = sort(images);
end
if ask_for_confirmation
    fprintf(1,'NOTE: Ignoring Base image for alignment. Aligning planes to plane %d,\n',min(imlist));    
end

global additional_settings;
if additional_settings.smooth_masses_kernelsize(2)>1
    fprintf(1,'NOTE: images are smoothed (kernel size %d) before registration.\n',...
        additional_settings.smooth_masses_kernelsize(2))
end
        
%% find alignment tforms for each image in IM that is in the imlist   

% first set optimizer settings (this is left out because I do not really
% understand what they mean, and trials didn't lead to understanding)
[optimizer, metric] = imregconfig('monomodal');
if 0
    optimizer.MinimumStepLength = 1e-3;
    optimizer.MaximumStepLength = 0.9e-1;
    optimizer.MaximumIterations = 30;
end

%% find the transformation forms; imlist(1) is the "base image"
t1 = clock;
for kk=2:length(imlist)

    ifixed = imlist(kk-1);
    imoving = imlist(kk);
    fixed = double(im(yreg,xreg,ifixed));
    moving = double(im(yreg,xreg,imoving));

    % perform smoothing (needed for very noisy images)
    if 1
        fixed = smooth_2D_image(fixed, additional_settings.smooth_masses_kernelsize(2));
        moving = smooth_2D_image(moving, additional_settings.smooth_masses_kernelsize(2));        
        %fixed = medfilt2(fixed,[3 3]);
        %moving = medfilt2(moving,[3 3]);
    end
    
    fixed2 = double(im(:,:,ifixed));
    moving2 = double(im(:,:,imoving));

    fprintf(1,'Aligning image %d/%d:\t',imoving,imlist(end));

    % added 4-6-2018

    % attempt affine transformation consisting of translation, rotation, scale, and shear
    %tform{imoving} = imregtform(moving, fixed, 'affine', optimizer, metric);
    % normally, look only for translational alignment
    tform{imoving} = imregtform(moving, fixed, 'translation', optimizer, metric);
    if be_verbous
        movingRegistered2 = imwarp(moving2,tform{imoving},'OutputView',imref2d(size(fixed2)));
    end

    % accumulate the transformation matrix in the tform
    tform{imoving}.T = (tform{imoving}.T)*(tform{ifixed}.T);
    fprintf(1,'[%.2f %.2f]\n',tform{imoving}.T(3,[2 1]));

    % for debugging, display the matrix of scalar product scores
    if be_verbous
        if kk==2
            figure(30);
            s1=subplot(2,2,1);
            imagesc(fixed); t1=title(sprintf('fixed %d',ifixed)); colorbar;
            s2=subplot(2,2,2);
            imagesc(moving); t2=title(sprintf('moving %d',imoving)); colorbar;
            s3=subplot(2,2,3);
            imagesc(moving2-fixed2); title('moving - fixed'); colorbar
            s4=subplot(2,2,4);
            imagesc(movingRegistered2-fixed2); title('registered moving - fixed'); colorbar
            colormap(get_colormap(additional_settings.colormap));    
        else
            set(s1.Children,'CData',fixed);
            set(s2.Children,'CData',moving);
            set(s3.Children,'CData',moving2-fixed2);
            set(s4.Children,'CData',movingRegistered2-fixed2);
            set(t1,'string',sprintf('fixed %d',ifixed));
            set(t2,'string',sprintf('moving %d',imoving));
            pause(0.2);
        end
    end

end
    
%% apply the tforms to the respective planes
% to be able to show the alignment quality and ask for approval
if ask_for_confirmation
    fprintf(1,'Accumulating base mass ... ');
end
ifixed = imlist(1);
fixed2 = double(im(:,:,ifixed));
for kk=1:length(imlist)
    imoving = imlist(kk);    
    moving2 = double(im(:,:,imoving));    
    movingRegistered2(:,:,imoving) = imwarp(moving2,tform{imoving},'OutputView',imref2d(size(fixed2)));
    xyalign(imoving,:) = tform{imoving}.T(3,[2 1]);
    if be_verbous
        if kk==1
            figure(30);
            s1=subplot(2,2,1);
            imagesc(fixed2); t1=title(sprintf('fixed %d',ifixed)); colorbar;
            s2=subplot(2,2,2);
            imagesc(moving2); t2=title(sprintf('moving %d',imoving)); colorbar;
            s3=subplot(2,2,3);
            imagesc(fixed2-moving2); colorbar; title('fixed - moving');
            s4=subplot(2,2,4);
            imagesc(fixed2-movingRegistered2(:,:,imoving)); colorbar; title('fixed - movingRegistered');
        else
            set(s1.Children,'CData',fixed2);
            set(s2.Children,'CData',moving2);
            set(s3.Children,'CData',fixed2-moving2);
            set(s4.Children,'CData',fixed2-movingRegistered2(:,:,imoving));
            set(t1,'string',sprintf('fixed %d',ifixed));
            set(t2,'string',sprintf('moving %d',imoving));
            pause(0.2);
        end
    end
end
%fprintf(1,'Done.\n');

t2=clock;
if ask_for_confirmation
    fprintf(1,'Alignment of the selected planes for the base mass done in %.3fs\n',etime(t2,t1));
end

%% show final stacks to check that the alignment went well
if ~ask_for_confirmation
    f40 = [];
    choice = 'Apply';
else
    
    f40=figure(40);
    N=3;
    ind1 = round(size(movingRegistered2,1)/2);
    ind2 = round(size(movingRegistered2,2)/2);

    subplot(2,2,1);
    imagesc(squeeze(sum(movingRegistered2(ind1+[-N:N],:,imlist),1)));
    title('Accumulated - dim 1')
    subplot(2,2,2);
    imagesc(squeeze(sum(movingRegistered2(:,ind2+[-N:N],imlist),2)));
    title('Accumulated - dim 2')
    subplot(2,2,3);
    imagesc(squeeze(sum(movingRegistered2(:,:,imlist),3)));
    title('Accumulated - dim 3')
    subplot(2,2,4);
    hold off
    plot(imlist,xyalign(imlist,1),'rx-');
    hold on
    plot(imlist,xyalign(imlist,2),'b+-');
    legend('x','y');
    xlabel('plane');
    title('Alignment co-ordinates');
    ylabel('x and y (pix)');
    colormap(get_colormap(additional_settings.colormap));
    btn1 = uicontrol(f40,'Style', 'pushbutton', 'String', 'Apply',...
        'Units','normalized', 'Position', [0.38 0.01 0.1 0.05],...
        'BackgroundColor',[0 0.6 0],'ForegroundColor',[1 1 1],'FontWeight', 'bold', ...
        'Callback', @btn1_pressed);
    btn2 = uicontrol(f40,'Style', 'pushbutton', 'String', 'Reject', ...
        'Units','normalized', 'Position', [0.52 0.01 0.1 0.05],...
        'BackgroundColor',[0.8 0 0],'ForegroundColor',[1 1 1],'FontWeight', 'bold', ...
        'Callback', @btn2_pressed);

    fprintf(1,'XY-alignment data generated. Use Figure 40 to confirm whether you want to apply it to all masses or reject.\n')

    set(f40,'WindowStyle','modal')

    choice = 'Reject';

    % UIWAIT makes gui_test2 wait for user response (see UIRESUME)
    uiwait(f40);
end

    function btn1_pressed(source,event)
    choice = 'Apply';
    %fprintf(1,'%s\n',choice);
    %delete(f40);
    set(f40,'WindowStyle','normal')
    delete(btn1);
    delete(btn2);
    uiresume(f40)
    end

    function btn2_pressed(source,event)
    choice = 'Reject';
    %fprintf(1,'%s\n',choice);
    %delete(f40);
    set(f40,'WindowStyle','normal')
    delete(btn1);
    delete(btn2);
    uiresume(f40)
    end

end