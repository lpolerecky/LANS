function plot_3D_sections(f1,d,x,y,wx,wy,wz,fname,mass,logf,rgb_flags,printf,quant)

if nargin>12
    q=quant;
else
    global additional_settings;
    q=additional_settings.autoscale_quantiles;
end

rgb=sum(rgb_flags);

% plot stacks of one of the masses
if rgb==1
    ind=find(rgb_flags==1);
    d=d{ind};
    mass=mass{ind};
    [xstack,ystack,zstack,xs,ys,h,w,l,dx,dy]=get_stacks(d,x,y,wx,wy,wz,logf);
    fig=display_stacks(f1,xstack,ystack,zstack,xs,ys,q,h,w,l,dx,dy,fname,mass);
    print_stacks(fig,fname,mass,printf);
end

% plot stacks of more than one of the masses
if rgb>1
    % find the size (h,w,l) of the stacks
    ind=find(rgb_flags==1);    
    [xstack,ystack,zstack,xs,ys,h,w,l,dx,dy]=get_stacks(d{ind(1)},x,y,wx,wy,wz,logf);
    % fill r,g,b channels with the respective data
    % to be continued
    massname=[];
    if rgb_flags(1)==1
        [xstack1,ystack1,zstack1,xs1,ys1]=get_stacks(d{1},x,y,wx,wy,wz,logf);
        massname=[massname mass{1}];
    else
        xstack1=zeros(size(xstack));
        ystack1=zeros(size(ystack));
        zstack1=zeros(size(zstack));
        xs1=zeros(size(xs));
        ys1=zeros(size(ys));
    end
    if rgb_flags(2)==1
        [xstack2,ystack2,zstack2,xs2,ys2]=get_stacks(d{2},x,y,wx,wy,wz,logf);
        if ~isempty(massname)
            massname=[massname '-' mass{2}];
        else
            massname=[massname mass{2}];
        end
    else
        xstack2=zeros(size(xstack));
        ystack2=zeros(size(ystack));
        zstack2=zeros(size(zstack));
        xs2=zeros(size(xs));
        ys2=zeros(size(ys));
    end
    if rgb_flags(3)==1
        [xstack3,ystack3,zstack3,xs3,ys3]=get_stacks(d{3},x,y,wx,wy,wz,logf);
        if ~isempty(massname)
            massname=[massname '-' mass{3}];
        else
            massname=[massname mass{3}];
        end
    else
        xstack3=zeros(size(xstack));
        ystack3=zeros(size(ystack));
        zstack3=zeros(size(zstack));
        xs3=zeros(size(xs));
        ys3=zeros(size(ys));
    end
    fig=display_stacks_rgb(f1,{xstack1,xstack2,xstack3},...
        {ystack1,ystack2,ystack3},...
        {zstack1,zstack2,zstack3},...
        {xs1,xs2,xs3},{ys1,ys2,ys3},q,h,w,l,dx,dy,fname,massname);
    massname=strrep(massname,'(','');
    massname=strrep(massname,')','');
    print_stacks(fig,fname,massname,printf);    
end



