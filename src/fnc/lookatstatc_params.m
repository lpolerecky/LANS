% input parameters required for processing by lookatstatc.m
% add the {if 0 ... end} structure at the end of this file, modify the
% input parameters and change {if 0} to {if 1}.

if 0
    dname='o:\nanoSIMS\2015\2015-11-06-GLENDON\';
    bname='2015-11-06-GLENDON_';
    id=[3:26];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)', '\delta(17O/18O)', '\delta(15N/14N)'};
    cnts = {'12C', '13C', '17O', '18O', '12C14N', '12C15N'};
    na = [ 0.0105, 0.03092/0.92223, 0.0037 ];
end;

if 0
    dname='o:\nanoSIMS\2015\2015-11-05-GLENDON\';
    bname='2015-11-05-GLENDON_';
    id=[1:14];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)', '\delta(17O/18O)', '\delta(15N/14N)'};
    cnts = {'12C', '13C', '17O', '18O', '12C14N', '12C15N'};
    na = [ 0.0105, 0.03092/0.92223, 0.0037 ];
end;

if 0
    dname='/home/lubos/expdata/nanosimsdata/michiel/2015-11-23-Si/';
    %bname='2015-11-23-Si_single_';
    bname='2015-11-23-Si_';
    id=[1:5];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(29Si/28Si)', '\delta(30Si/28Si)', '\delta(30Si/29Si)'};
    cnts = {'28Si', '29Si', '30Si'};
    na = [ 0.04685/0.92223, 0.03092/0.92223, 0.03092/0.04685 ];
end;

if 0
    dname='d:\data\2015-11-23-Si\';
    bname='2015-11-23-Si_single_';
    %bname='2015-11-23-Si_';
    id=[1:10];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(29Si/28Si)', '\delta(30Si/28Si)', '\delta(30Si/29Si)'};
    cnts = {'28Si', '29Si', '30Si'};
    na = [ 0.04685/0.92223, 0.03092/0.92223, 0.03092/0.04685 ];
end;

if 0
    dname='d:\data\2015-11-24-Si\';
    %bname='2015-11-23-Si_single_';
    bname='2015-11-24-Si-a_';
    id=[1:10];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(29Si/28Si)', '\delta(30Si/28Si)', '\delta(30Si/29Si)'};
    cnts = {'28Si', '29Si', '30Si'};
    na = [ 0.04685/0.92223, 0.03092/0.92223, 0.03092/0.04685 ];
end;

if 0
    dname='/home/lubos/expdata/nanosimsdata/michiel/2015-11-24-Si/';
    bname='2015-11-24-Si-a_';
    id=[1:10];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(29Si/28Si)', '\delta(30Si/28Si)', '\delta(30Si/29Si)'};
    cnts = {'28Si', '29Si', '30Si'};
    na = [ 0.04685/0.92223, 0.03092/0.92223, 0.03092/0.04685 ];
end;

if 0
    dname='d:\data\2015\2015-12-07-POLLEN\';
    bname='2015-12-07-POLLEN_4_';
    id=[1:5];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)'};
    cnts = {'12C', '13C'};
    na = [ 0.0105 ];
end;

if 0
    dname='d:\data\2015\2015-12-08-POLLEN\';
    bname='2015-12-08-POLLEN_3_is_';
    id=[1:10];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)', '\delta(15N/14N)'};
    cnts = {'12C', '13C', '12C14N', '12C15N'};
    na = [ 0.0105 0.0037];
end;

if 0
    dname='d:\data\2015\2015-12-09-POLLEN\';
    bname='2015-12-09-POLLEN_4_is_';
    id=[1:9];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)'};
    cnts = {'12C', '13C'};
    na = [ 0.0105 ];
end;

if 0
    dname='d:\data\2015\2015-12-09-POLLEN\';
    bname='2015-12-09-POLLEN_2_is_';
    id=[1:5];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)', '\delta(15N/14N)'};
    cnts = {'12C', '13C', '12C14N', '12C15N'};
    na = [ 0.0105 0.0037];
end;

if 0
    dname='d:\data\2015\2015-12-10-POLLEN\';
    bname='2015-12-10-POLLEN_3_is_';
    id=[1:5];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)', '\delta(15N/14N)'};
    cnts = {'12C', '13C', '12C14N', '12C15N'};
    na = [ 0.0105 0.0037];
end;

if 0
    dname='d:\data\2015\2015-12-11-POLLEN\';
    bname='2015-12-11-POLLEN_2_is_';
    id=[1:5];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)', '\delta(15N/14N)'};
    cnts = {'12C', '13C', '12C14N', '12C15N'};
    na = [ 0.0105 0.0037];
end;

if 0
    dname='d:\data\2015\2015-12-14-POLLEN\';
    bname='2015-12-14-POLLEN_';
    id=[3:7];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)', '\delta(15N/14N)'};
    cnts = {'12C', '13C', '12C14N', '12C15N'};
    na = [ 0.0105 0.0037];
end;

if 0
    dname='d:\data\2015\2015-12-15-POLLEN\';
    bname='isotopes_';
    id=[1:10];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)'};
    cnts = {'12C', '13C'};
    na = [ 0.0105 ];
end;

if 1
    dname='d:\data\2015-12-17-POLLEN\';
    bname='2015-12-17-POLLEN__';
    id=[1:10];
    suffix='.statc';
    suffix2='.is_txt';
    ratios = {'\delta(13C/12C)'};
    cnts = {'12C', '13C'};
    na = [ 0.0105 ];
end;

