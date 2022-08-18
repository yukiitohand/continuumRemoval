clear all
close all
clc
%%
%add frame to the map
fNameIn = 'C:\Users\arunsaranath\Downloads\bandPosMaps\FRT0000AA7D\AA7D_bandMaps.img';
[im1,~] =enviread(fNameIn);
%%
%read in the TER info
fHdrIn = 'C:\Users\arunsaranath\Downloads\bandPosMaps\FRT0000AA7D\FRT0000AA7D_07_IF166J_TER3.HDR';
info = read_envihdr(fHdrIn);

%%
imFrame = 65535 *ones(info.lines,info.samples,info.bands);
loc1=291;
loc2=306;
imFrame(2:479,32:631,loc1) = im1(:,:,1);
imFrame(2:479,32:631,loc2) = im1(:,:,2);
for j=1:info.bands
    if((j~=loc1)&&(j~=loc2))
        imFrame(2:479,32:631,j) = zeros(size(im1(:,:,1)));
    end
end
fnameOut = strrep(fHdrIn,'.HDR','_colAvg_crsdspk_dspk_bandMap_bands22002300_frame_4grf.img')
%%
i = enviwrite2(imFrame,fnameOut,info);
%%
imFrame_v1 = 65535 *ones(info.lines,info.samples,info.bands);
loc3=300;
imFrame_v1(2:479,32:631,loc3) = squeeze(im1(:,:,1).*im1(:,:,2));
for j=1:info.bands
    if((j~=loc3))
        imFrame(2:479,32:631,j) = zeros(size(im1(:,:,1)));
    end
end

fnameOut = strrep(fHdrIn,'.HDR','_colAvg_crsdspk_dspk_bandMap_indBands_frame_4grf.img')
%%
i = enviwrite2(imFrame_v1,fnameOut,info);
% %%
% infod.default_bands=[];
% infod.wavelength_units=[];
% infod.wavelength=[];
% infod.fwhm=[];
% infod.bbl=[];
% 
% fHdrOut = strrep(fnameOut,'.img','.img.hdr');
% envihdrwrite_yuki(infod,fHdrOut)
% %%
% temp = imFrame_v1;
% temp(temp>0)=1;
% 
% figure()
% imagesc(temp)