clear all
close all
clc
%%
%add frame to the map
fNameIn = 'C:\Users\arunsaranath\Downloads\FRT0000A425\FRT0000A425_07_IF166J_TER3_CROP_colAvg_crsdspk_dspk_bandMaps.img';
[im,~] =enviread(fNameIn);
%%
%read in the TER info
fHdrIn = 'C:\Users\arunsaranath\Downloads\bandPosMaps\FRT0000A425\FRT0000A425_07_IF166J_TER3.HDR';
info = read_envihdr(fHdrIn);

%%
imFrame = 65535 *ones(info.lines,info.samples,info.bands);
loc = 291;
imFrame(2:479,32:631,loc) = im;
for j=1:info.bands
    if(j~=loc)
        imFrame(2:479,32:631,j) = zeros(size(im));
    end
end

fnameOut = strrep(fHdrIn,'.HDR','_colAvg_crsdspk_dspk_bandMap_indBands_frame_4grf.img');
%%
i = enviwrite2(imFrame,fnameOut,info);
%%
% fHdrOut = strrep(fnameOut,'.img','.img.hdr');
% dbstop in envihdrwrite_yuki.m
% envihdrwrite_yuki(info,fHdrOut)
