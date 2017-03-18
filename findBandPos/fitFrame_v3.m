clear all
close all
clc
%%
%add frame to the map
fNameIn = 'C:\Users\arunsaranath\Downloads\bandPosMaps\HRL000043EC\43EC_bandMaps.img';
[im1_temp,~] =enviread(fNameIn);
im1 = zeros(480,320,2);
im1(2:479,32:311,1) = im1_temp(:,:,1);
im1(2:479,32:311,2) = im1_temp(:,:,2);
%%
%read in the TER info
fHdrIn = 'C:\Users\arunsaranath\Downloads\bandPosMaps\HRL000043EC\HRL000043EC_07_IF183J_TER3.HDR';
info = read_envihdr(fHdrIn);
%%
imFrame = 65535 *ones(info.lines,info.samples,info.bands);
loc1=291;
loc2=306;
imFrame(2:479,18:314,loc1) = im1(2:479,18:314,1);
imFrame(2:479,18:314,loc2) = im1(2:479,18:314,2);

for j=1:info.bands
    if((j~=loc1)&&(j~=loc2))
        imFrame(2:479,18:314,j) = zeros(size(im1(2:479,18:314,1)));
    end
end

fnameOut = strrep(fHdrIn,'.HDR','_colAvg_crsdspk_dspk_bandMap_bands22002300_frame_4grf.img')
%%
i = enviwrite2(imFrame,fnameOut,info);
%%
imFrame_v1 = 65535 *ones(info.lines,info.samples,info.bands);
loc1=300;
imFrame_v1(2:479,18:314,loc1) = im1(2:479,18:314,1).*im1(2:479,18:314,2);
for j=1:info.bands
    if((j~=loc1))
        imFrame(2:479,18:314,j) = zeros(size(im1(2:479,18:314,1)));
    end
end

fnameOut = strrep(fHdrIn,'.HDR','_colAvg_crsdspk_dspk_bandMap_indBands_frame_4grf.img')
%%
i = enviwrite2(imFrame_v1,fnameOut,info);
