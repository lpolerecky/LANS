function [im,pp,p]=read_im_file(ff,ask_for_planes)

% Read the binary im file produced by the NanoSIMS 50L machine, and output
% the raw images as well as the additional parameters characterizing the
% dataset.
% NOTE: I don't know why, but data in some binary files are stored as uint8
% (e.g. from MPI Bremen), and in some others they are stored as ushort
% (e.g., IoW Warnemuende). It seems that this difference can be "detected"
% based on the value of the pixel_size in the Header_image structure.
% Therefore, the below coding relies on this to automatically find out how
% the binary data should be read.
% updated: L.P. 22-08-2012

if nargin>1
    afp=ask_for_planes;
else
    afp=0;
end;

% some definitions
b8=2^8;
ttype = 'uint8';
num_bytes = 4;

% read the binary *.im file (header and the data afterwards)
disp(['Reading file ',ff,' ... ']);
fid=fopen(ff,'r');

% default flag for byte ordering, will be verified later
reverse_bytes = 0;

% default offset, will be modified later
offset = 452+8;
offset_old = offset;

% read the header size first, on byte 8. if the value is too large, which
% is indicative of reverse ordering of the bytes (i.e. that the file was
% generated under Windows), set the flag for the reverse byte ordering to
% 1. Also, change the offset value, which is used to read the masses in the
% binary file. (I don't have a clue why this offset depends on this, but it
% does, and I had to do it with a trial-and-error approach to find out the
% correct offset values for both types of data).
hsize = read_bytes(fid, 8, num_bytes, ttype, reverse_bytes, b8);
if hsize>2e6
   reverse_bytes = ~reverse_bytes;
   offset = 412+1*192+56;
end;

% read all the parameters in the header, at the positions specified in the
% documentation
release = read_bytes(fid, 0, num_bytes, ttype, reverse_bytes, b8);
analysis_type = read_bytes(fid, 4, num_bytes, ttype, reverse_bytes, b8);
hsize = read_bytes(fid, 8, num_bytes, ttype, reverse_bytes, b8);
sample_type = read_bytes(fid, 12, num_bytes, ttype, reverse_bytes, b8);
data_present = read_bytes(fid, 16, num_bytes, ttype, reverse_bytes, b8);
sple_pos_x = read_bytes(fid, 20, num_bytes, ttype, reverse_bytes, b8);
sple_pos_y = read_bytes(fid, 24, num_bytes, ttype, reverse_bytes, b8);
analysis_name = read_bytes(fid, 28, 32, 'char', 0, b8);
username = read_bytes(fid, 60, 16, 'char', 0, b8);
samplename = read_bytes(fid, 76, 16, 'char', 0, b8);
ddate = remove_blanks(read_bytes(fid, 92, 16, 'char', 0, b8));
ttime = remove_blanks(read_bytes(fid, 108, 16, 'char', 0, b8));
filename = read_bytes(fid, 124, 16, 'char', 0, b8);
anal_duration = read_bytes(fid, 140, num_bytes, ttype, reverse_bytes, b8);
cycle_number = read_bytes(fid, 144, num_bytes, ttype, reverse_bytes, b8);
scantype = read_bytes(fid, 148, num_bytes, ttype, reverse_bytes, b8);
magnification = read_bytes(fid, 152, 2, ttype, reverse_bytes, b8);
sizetype = read_bytes(fid, 154, 2, ttype, reverse_bytes, b8);
size_detector = read_bytes(fid, 156, 2, ttype, reverse_bytes, b8);
no_used = read_bytes(fid, 158, 2, ttype, reverse_bytes, b8);
beam_blanking = read_bytes(fid, 160, num_bytes, ttype, reverse_bytes, b8);
pulverisation = read_bytes(fid, 164, num_bytes, ttype, reverse_bytes, b8);
pulve_duration = read_bytes(fid, 168, num_bytes, ttype, reverse_bytes, b8);
auto_cal_in_anal = read_bytes(fid, 172, num_bytes, ttype, reverse_bytes, b8);
autocal = read_bytes(fid, 176, 72, ttype, reverse_bytes, b8);
sig_reference = read_bytes(fid, 248, num_bytes, ttype, reverse_bytes, b8);
sigref = read_bytes(fid, 252, 156, ttype, reverse_bytes, b8);
nb_mass = read_bytes(fid, 408, num_bytes, ttype, reverse_bytes, b8);

% set to if 1 during debuging
if 0 
    ftmp=fopen([pwd delimiter 'tmp.txt'],'w');
    fprintf(ftmp,'%f\n%f\n%f\n%f\n%f\n%f\n%f\n',release, analysis_type, hsize, ...
        sample_type, data_present, sple_pos_x, sple_pos_y);
    fprintf(ftmp,'%s\n%s\n%s\n%s\n%s\n%s\n',analysis_name, username, samplename, ...
        ddate, ttime, filename);
    fprintf(ftmp,'%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n',...
        anal_duration, cycle_number, scantype, magnification, sizetype, size_detector,...
        no_used, beam_blanking, pulverisation, pulve_duration, auto_cal_in_anal, ...
        autocal, sig_reference, sigref, nb_mass);
    fclose(ftmp);
end;

% find the names and masses of the detected ions (I had to figure this out
% by trial and error, as the documentation did not really correspond to the
% final result).
at_mass = [];
mass_name = [];
for ii=0:(nb_mass-1)
    [m1,h] = read_bytes(fid, offset+ii*192, 8, 'uint8', ~reverse_bytes, b8);
    at_mass(1,ii+1) = typecast(uint8(h),'double');
    [m1,h] = read_bytes(fid, offset+52+ii*192, 64, 'char', 0, b8);
    if at_mass(1,ii+1)==0
        mass_name{ii+1}='Esi';
    else
        if isempty(remove_blanks(m1))
            % sometimes the element name is missing (such as in a file 
            % provided by Anand), so guess it or return AU (for atomic
            % units)
            switch round(at_mass(1,ii+1))
                case 14, mn='14C';
                case 33, mn='33S';
                otherwise, mn=[num2str(round(at_mass(1,ii+1))) 'AU'];
            end;
            mass_name{ii+1} = mn;
        else
            mass_name{ii+1} = remove_blanks(m1);
        end;
    end;
end;

% for some unknown reason, the offset for reading the masses is not
% consistent between files produced in different laboratories, leading to
% at_mass(ii) = 0  for all ii. If this happens, read thd atomic masses
% again, with the old offset (reported by Kate Lewis)
if sum(at_mass)==0
    fprintf(1,'*** Warning; Unusual input formatting. The originally detected masses may not be correct.\n');
    fprintf(1,'    Trying again with a different offset.\n');
    for ii=0:(nb_mass-1)
        [m1,h] = read_bytes(fid, offset_old+ii*192, 8, 'uint8', ~reverse_bytes, b8);
        at_mass(1,ii+1) = typecast(uint8(h),'double');
        [m1,h] = read_bytes(fid, offset_old+52+ii*192, 64, 'char', 0, b8);
        if at_mass(1,ii+1)==0
            mass_name{ii+1}='Esi';
        else
            mass_name{ii+1} = remove_blanks(m1);
        end;
    end;
end;    

% 
% read other properties of the images
width = read_bytes(fid, hsize-78, 2, 'uint8', reverse_bytes, b8);
height = read_bytes(fid, hsize-76, 2, 'uint8', reverse_bytes, b8);
pixel_size = read_bytes(fid, hsize-74, 2, 'uint8', reverse_bytes, b8);
n_images = read_bytes(fid, hsize-72, 2, 'uint8', reverse_bytes, b8);
n_planes = read_bytes(fid, hsize-70, 2, 'uint8', reverse_bytes, b8);
raster = read_bytes(fid, hsize-68, 4, 'uint8', reverse_bytes, b8);
nickname = read_bytes(fid, hsize-64, 64, 'char', 0, b8);
orig_pixel_size = read_bytes(fid, hsize-1, 2, 'uint8', reverse_bytes, b8);

% hack by LP: 04-04-2016
% Raster does not seem to be correctly stored in the im file. We will
% therefore recalculate it based on the values of m_nNX_max and
% m_nNX_low/high.
nb_poly = read_bytes(fid, 652+288*nb_mass+16, 1, ttype, reverse_bytes, b8);
m_nNX_max = read_bytes(fid, 676+288*nb_mass+144*nb_poly+28, 2, ttype, reverse_bytes, b8);
m_nNY_max = read_bytes(fid, 676+288*nb_mass+144*nb_poly+32, 2, ttype, reverse_bytes, b8);
m_nNX_low = read_bytes(fid, 676+288*nb_mass+144*nb_poly+36, 2, ttype, reverse_bytes, b8);
m_nNX_high = read_bytes(fid, 676+288*nb_mass+144*nb_poly+40, 2, ttype, reverse_bytes, b8);
m_nNY_low = read_bytes(fid, 676+288*nb_mass+144*nb_poly+44, 2, ttype, reverse_bytes, b8);
m_nNY_high = read_bytes(fid, 676+288*nb_mass+144*nb_poly+48, 2, ttype, reverse_bytes, b8);
% in some im file the above values are all zeros, so to prevent wrong
% setting of the raster, I had to introduce this condition. I really don't
% understand why the data are not compatible... :(
if ( (m_nNX_high-m_nNX_low+1)>0 ) & m_nNX_max>0
    raster = raster * (m_nNX_high-m_nNX_low+1)/m_nNX_max;
end;

%% this is used when the full binary data is going to be read

% this is where it is determined how to read the binary data
if pixel_size == 2
    bin_format = 'uint8';
else
    bin_format = 'ushort';
end;

% for some unknown reason, if the measurement was interrupted, n_planes may
% be equal to 0. in this case calculate the number of truly stored planes
% in the file from the number of masses and the size of the imaged area
if n_planes == 0   
    fileInfo = dir(ff);
    n_planes=round((fileInfo.bytes-hsize)/(width*height*pixel_size*n_images));
end;

% true number of detected planes
Nptrue = n_planes;
fprintf(1,'Total number of detected planes: %d\n',Nptrue);
fprintf(1,'Size of the images: %d x %d pix\n',width,height);
fprintf(1,'Total number of detected masses: %d\n',length(mass_name));
dwell_time_factor = ceil(length(mass_name)/8);
if dwell_time_factor>1
    fprintf(1,'Number of detected masses is greater than 8. Dwell time will be corrected by a factor of %d\n',dwell_time_factor);
end;

% position of the 1st byte of the 1st plane of the 1st mass
p1 = hsize;

% ask for specific planes and masses that should be loaded from the im file
if afp
    pm=listdlg('ListString',mass_name,'SelectionMode','multiple',...
        'InitialValue',[1:length(mass_name)],...
        'PromptString','Which masses you want to load?',...
        'ListSize',[230 130],'Name','Detected masses');        
    pm_selected_empty=0;
    if isempty(pm)
        pm=[1:length(mass_name)];
        pm_selected_empty=1;
    end;
    mass_name = {mass_name{pm}};
    at_mass = at_mass(pm);

    pp = inputdlg('Which planes do you want to load?','Detected planes',1,...
        {sprintf('%d:%d',1,Nptrue)});

    if isempty(pp)
        Np=Nptrue;
        pp=[1:Np];
    else
        pp=str2num(pp{1});
        ind=find(pp<=Nptrue);
        pp=pp(ind);
        Np=length(pp);
    end;
else
    Np=Nptrue;
    pp=[1:Np];
    pm=1:nb_mass;
end;
fprintf(1,'Number of planes to be loaded: %d\n',Np);

% now read the image data for all selected masses and planes from byte p1
fseek(fid,p1,'bof');
kk=0;
N = width*height*2;
fprintf(1,'Loading planes (out of %d):\n',length(pp));
for ii=1:Nptrue

    tmpim=[];

    for jj=1:nb_mass

        % read the image data in the specified bin_format (see above)
        [d12,count]=fread(fid,N,bin_format);

%         if ii==8
%             a=1;
%         end;

        if count>0

            % get the higher and lower bytes and calculate the final image
            d1=d12(1:2:N);
            d2=d12(2:2:N);
            if reverse_bytes
                % when data have been stored under Windows
                d=d2*b8+d1;
            else
                % when data have been stored under Unix
                d=d1*b8+d2;
            end;
            a=vec2mat(d,width);

            % for debugging, set this to 1 if you want to display every read image
            if 0
                figure(19); 
                imagesc(a);
                set(gca,'dataaspectratio',[1 1 1]);
                title(sprintf('plane=%d, mass=%d',ii,jj));
                colormap(gray);            
                pause(0.5);
                input('Press enter to continue');
            end;

        else

            fprintf(1,'No data for plane %d\n',ii);
            a=[];

        end;

        % fill the matrices of the masses
        if nb_mass==1
            tmpim = uint16(a); %double(a);
        else
            tmpim{jj} = uint16(a); %double(a);
        end;

    end;

    % if the currently read plane is in the selected list of planes, and
    % the currently mass in the selected list of masses, 
    % add it to im{jj}(:,:,:) at index kk, for all masses
    if sum(ismember(pp,ii))>0
        kk=kk+1;
        %for jj=1:nb_mass
        for jj=1:length(pm)
            if nb_mass==1
                im{jj}(:,:,kk) = tmpim;
            else
                im{jj}(:,:,kk) = tmpim{pm(jj)};
            end;
        end;
        fprintf(1,'%d ',ii);
        if mod(kk,30)==0
            fprintf(1,'\n');
        end;
    else
        if ii==(pp(end)+1)
            fprintf(1,'\nPlease be patient until the im file is fully processed.\n');
        end;
    end;
    if ii==Nptrue
        fprintf(1,'\nDone.\n');
    end;
    
end;

fclose(fid);

[pathstr, name, ext] = fileparts(ff);
if length(pp)==Nptrue & length(pm)==nb_mass
    p.filename = [pathstr delimiter name];
else
    s=[];
    if length(pp)<Nptrue
        s=sprintf('_p%d-%d',pp(1),pp(end));
    end;         
    p.filename = sprintf('%s%c%s',pathstr,delimiter,name,s);
end;
    
%fprintf(1,'Done.\n%d planes (%d-%d) stored.\n',kk,pp(1),pp(end));

% put the additional useful parameters to a structure p
p.reverse_bytes = reverse_bytes;
p.pos = [sple_pos_x sple_pos_y 0];
p.mass = mass_name;
p.mass_precise = at_mass;
p.date = ddate;
p.time = ttime;
p.width = width;
p.height = height;
p.scale = raster/1000;

% calculate also dwell time, estimated from the analysis duration
p.dwell_time = round(anal_duration/cycle_number/width/height*1000/dwell_time_factor); % in msec
fprintf(1,'Dwell time estimated from analysis duration, image size and cycle number: %d ms\n',p.dwell_time);

% left here for debugging
a=0;