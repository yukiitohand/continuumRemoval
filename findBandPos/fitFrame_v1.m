clear all
close all
clc
%%
%add frame to the map
fNameIn = 'C:\Users\arunsaranath\Downloads\FRT0000A425\FRT0000A425_07_IF166J_TER3_CROP_colAvg_crsdspk_dspk_bandMap_2200.img';
[im1_temp,~] =enviread(fNameIn);
im1 = zeros(478,600,1);
im1(2:477,2:599,:)  = im1_temp(:,:,1);


fNameIn = 'C:\Users\arunsaranath\Downloads\FRT0000A425\FRT0000A425_07_IF166J_TER3_CROP_colAvg_crsdspk_dspk_bandMap_2300.img';
[im2_temp,~] =enviread(fNameIn);
im2 = zeros(478,600,1);
im2(2:477,2:599,:)  = im2_temp(:,:,1);

%%
%read in the TER info
fHdrIn = 'C:\Users\arunsaranath\Downloads\bandPosMaps\FRT0000A425\FRT0000A425_07_IF166J_TER3.HDR';
info = read_envihdr(fHdrIn);

%%
imFrame = 65535 *ones(480,640,2);
loc1=291;
loc2=306;
imFrame(2:479,32:631,loc1) = im1;
imFrame(2:479,32:631,loc2) = im2;
for j=1:info.bands
    if((j~=loc1)&&(j~=loc2))
        imFrame(2:479,32:631,j) = zeros(size(im1));
    end
end

fnameOut = strrep(fHdrIn,'.HDR','_colAvg_crsdspk_dspk_bandMap_bands22002300_frame_4grf.img')
% infod = info;
% infod.bands = 2;

%%
i = enviwrite2(imFrame,fnameOut,info);
% %%
% infod.default_bands=[];
% infod.wavelength_units=[];
% infod.wavelength=[];
% infod.fwhm=[];
% infod.bbl=[];
% 
% fHdrOut = strrep(fnameOut,'.img','.img.hdr');
% envihdrwrite_yuki(infod,fHdrOut)
