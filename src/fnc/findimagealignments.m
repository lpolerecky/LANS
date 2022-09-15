function [xyalign, images, f40, choice] = findimagealignments(im,images,imageind,x_special,y_special,maxalign)
% Find alignment co-ordinates based on the specified images

% 26.04.2009, Lubos Polerecky 
% 02.12.2010, improvement by LP: the calculation of the misalignment of the
% subsequent image in the stack is started from the misalignment of the
% previous image. because the max-misalignment is dynamically changed based
% on the last misalignment, this speeds up the overall procedure. when the
% dynamically changed misalignment increases above 20, the image is left
% out from the accummulation.

% define some artificially misaligned images for debugging purposes
if 0
    im=zeros(128,128,5);
    im(64,64,1)=1;
    im(65,64,2)=1;
    im(66,64,3)=1;
    im(66,64,4)=1;
    im(66,65,5)=1;
    images=[1:5];
    imageind=1;
    x_special=[1:128];
    y_special=[1:128];
    maxalign=3;
end

fprintf(1,'*** This is findimagealignments ***\n');

% default output = no transformation
xyalign = zeros(size(im,3),2);

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

% align all images in case the IMAGES is empty
if isempty(images)
    images = [1:size(im,3)];
else
    images = sort(images);
end

% generate the image lists based on which the images will be aligned
k = find(images==imageind);
imlist1=images(k-1:-1:1);
imlist2=images(k+1:1:length(images));

if isempty(k)
    fprintf(1,'ERROR: Index of the Base image for alignment is outside the interval of planes selected for alignment.\n')
    fprintf(1,'Producing empty output.\n');
    xyalign = [];
    images = [];
    f40 = [];
    choice = 'Empty';
else

    % find alignment coordinates for each image in IM that is in the imlists    
    for imlists=1:2

        if imlists==1
            imlist=imlist1;
        else
            imlist=imlist2;
        end

        % this is the first base-image to which the next one will be aligned
        imreg=[];
        imreg(:,:)=double(im(yreg,xreg,imageind));
        imreg = medfilt2(imreg,[3 3]);    
        % removed 20-11-2014
        %imreg = (imreg-mean(imreg(:)))/var(imreg(:));
        imreg = (imreg-min(imreg(:)))/var(imreg(:));
        % added 20-11-2014
        imreg = log10(imreg+0.1*(max(imreg(:))-min(imreg(:))));

        lastx=0;
        lasty=0;
        if size(im,1)>256
            maxalign=20;
        elseif size(im,1)>128
            maxalign=10;
        else
            maxalign=5;
        end

        for kk=1:length(imlist)

            ii = imlist(kk);

            cim2d=[];
            maxt=maxalign*1;
            tmpi=[];     
            tmpi(:,:)=double(im(yreg,xreg,ii));
            tmpi = medfilt2(tmpi,[3 3]);        
            % removed 20-11-2014
            %tmpi = (tmpi-mean(tmpi(:)))/var(tmpi(:));
            tmpi = (tmpi-min(tmpi(:)))/var(tmpi(:));
            % added 20-11-2014
            tmpi = log10(tmpi+0.1*(max(tmpi(:))-min(tmpi(:))));
            fprintf(1,'Aligning image %d/%d\n',ii,imlist(end));

            %tmpi=tmpi3;

            % calculate the 2D-convolution matrix cim2d
            for xi=[-maxt:maxt]
                for yi=[-maxt:maxt]
                    true_xi = xi+1*lasty; %change this to 0 if alg2
                    true_yi = yi+1*lastx; %change this to 0 if alg2
                    se=translate(strel(1),[true_yi,true_xi]);
                    Ci2=imdilate(tmpi,se);
                    if(true_xi<0)
                        xind=[1:(size(tmpi,2)+true_xi)];
                    else
                        xind=[(true_xi+1):size(tmpi,2)];
                    end
                    if(true_yi<0)
                        yind=[1:(size(tmpi,1)+true_yi)];
                    else
                        yind=[(true_yi+1):size(tmpi,1)];
                    end                   
                    a=double(Ci2(yind,xind));
                    b = imreg(yind,xind);
                    %cim2d(yi+maxt+1,xi+maxt+1) = sum((a(:)-b(:)).^2)/length(a);
                    ab=(a(:)-b(:)).^2;
                    indab=find(ab>0);
                    cim2d(yi+maxt+1,xi+maxt+1) = std(ab(indab));
                end
            end

            % for debugging, display the matrix of scalar product scores
            if 0
                figure(30);
                subplot(2,2,1);
                imagesc(imreg); title('base image')
                subplot(2,2,2);
                imagesc(tmpi); title('image to be aligned')
                subplot(2,2,3);
                imagesc(flipud(cim2d'));
                subplot(2,2,4);
                imagesc(imreg-tmpi); title('image difference');
                %title(num2str(xyalign(ii,1:2)));
            end

            % find out where the cim2d is minimal, and assign the corresponding
            % misalignment distances to xyalign(ii,:)
            [m,i]=min(cim2d);
            [n,j]=min(m);
            xalign=i(j)-maxt-1;
            yalign=j-maxt-1;
            if abs(xalign)+abs(yalign)>0
                a=0;
            end
            %xyalign(ii,1:2)=[i(j)+1*lastx-maxt-1,j+1*lasty-maxt-1];
            xyalign(ii,1:2)=[xalign+lastx yalign+lasty];

            % if the cim2d maximum was reached at the edge of the alignment range,
            % increase maxalign and do the same image again!!!
            if max(abs([i(j)-maxt-1,j-maxt-1]))==maxalign
                fprintf(1,'Actual misalignment (%d,%d) reached maximum (%d). Recalculating the same image.\n',i(j)-maxt-1,j-maxt-1,maxalign);
                maxalign=maxalign+2;
                kk=kk-1;
            else
                % if the cim2d maximum was reached inside the max alignment range, continue
                % to the next image, remembering the current misalignment

                % increase maxalign if the currently calculated alignment was >=80% of maxalign
                if abs(i(j)-maxt-1)>=0.8*maxalign || abs(j-maxt-1)>=0.8*maxalign
                    maxalign=maxalign+1;
                else
                    % decrease maxalign if the currently calculated alignment was <80% of
                    % maxalign, but not below 3
                    if abs(i(j)-maxt-1)<0.8*maxalign && abs(j-maxt-1)<0.8*maxalign
                        diffx=maxalign-abs(i(j)-maxt-1);
                        diffy=maxalign-abs(j-maxt-1);
                        maxalign = maxalign - round(min(abs([diffx diffy]))/2);
                    end
                end

                % do not allow maxalign to decrease below 3 or increase above 20
                if maxalign<3
                    maxalign=3;
                end
                if maxalign>30
                    fprintf(1,'***\nMaximal misalignment exceeded 30, possibly due to serious drift in the planes.\n');
                    fprintf(1,'Plane %d removed from accumulation.\n',ii);
                    maxalign=30;
                    images = setdiff(images,ii);
                end

                % print results of the current image alignment
                fprintf(1,'Alignment: [%d %d] (max: %d)\n',xyalign(ii,1:2),maxalign);

                % remember the last optimum alignement, so that we can add it to
                % the alignment of the next image
                lastx=xyalign(ii,1);
                lasty=xyalign(ii,2);

                % remember the present image so that the next image will be
                % aligned to it
                %imreg=tmpi; %uncomment this if alg2

            end

        end

    end
    % insert also the base image
    imlist = sort([imageind imlist]);
    xyalign(imageind,:) = 0;

    %xyalign=round(xyalign/2);
    %[accu_im2, im2]=accumulate_images({im}, xyalign,1, {'Base mass for alignment'}, {imlist},1);
    [accu_im2, im2]=accumulate_images({im}, xyalign, {'Base mass for alignment'}, {imlist}, 1);
    accu_im2 = accu_im2{1};
    im2 = im2{1};



    % show final stacks to check that the alignment went well
    f40=figure(40);
    N=3;
    ind1 = round(size(im2,1)/2);
    ind2 = round(size(im2,2)/2);

    subplot(2,2,1);
    imagesc(squeeze(sum(im2(ind1+[-N:N],:,imlist),1)));
    title('Accumulated - dim 1')
    subplot(2,2,2);
    imagesc(squeeze(sum(im2(:,ind2+[-N:N],imlist),2)));
    title('Accumulated - dim 2')
    subplot(2,2,3);
    imagesc(accu_im2);
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
    global additional_settings;
    colormap(get_colormap(additional_settings.colormap));
    btn1 = uicontrol(f40,'Style', 'pushbutton', 'String', 'Apply',...
        'Units','normalized', 'Position', [0.38 0.01 0.1 0.05],...
        'BackgroundColor',[0 0.6 0],'ForegroundColor',[1 1 1],'FontWeight', 'bold', ...
        'Callback', @btn1_pressed);
    btn2 = uicontrol(f40,'Style', 'pushbutton', 'String', 'Reject', ...
        'Units','normalized', 'Position', [0.52 0.01 0.1 0.05],...
        'BackgroundColor',[0.8 0 0],'ForegroundColor',[1 1 1],'FontWeight', 'bold', ...
        'Callback', @btn2_pressed);

    fprintf(1,'XY-alignment data generated (see figure 40). Do you want to apply it to all masses or reject?\n')

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

a=0;

end
