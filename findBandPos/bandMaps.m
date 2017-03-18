clear all
close all
clc
%%
% enter image name and header name
fNameIn = 'C:\Users\arunsaranath\Downloads\FRT0000A425\FRT0000A425_07_IF166J_TER3_CROP_colAvg_crsdspk_dspk.img';
[im,info] = enviread(fNameIn);

% dbstop in robustFitVect.m at 30
[map22,map23]=robustFitVect(im,info.wavelength'/1000,ones(info.lines,info.samples),2,2,1);
%%
map = zeros(478,600);
map(2:477,2:599) = squeeze(map22(:,:,1) .* map23(:,:,1));
% map = map22(:,:,1) .* map23(:,:,1);

figure(1)
imagesc(squeeze(map))

infod = info;
infod.bands = 1;
fNameOut = 'C:\Users\arunsaranath\Downloads\FRT0000A425\FRT0000A425_07_IF166J_TER3_CROP_colAvg_crsdspk_dspk_bandMaps.img';
i=enviwrite2(map,fNameOut,infod)
%%
infod.bands=2;
infod.samples = 598;
infod.lines = 476;
fNameOut = 'C:\Users\arunsaranath\Downloads\FRT0000A425\FRT0000A425_07_IF166J_TER3_CROP_colAvg_crsdspk_dspk_bandMap_2200.img';
i=enviwrite2(map22,fNameOut,infod)
%%
fNameOut = 'C:\Users\arunsaranath\Downloads\FRT0000A425\FRT0000A425_07_IF166J_TER3_CROP_colAvg_crsdspk_dspk_bandMap_2300.img';
i=enviwrite2(map23,fNameOut,infod)
