function [delta,confidence] = phaseCorrRegistration(image1, image2, expectationR)
% function [delta,q] = phCorrReg(image1, image2, *expectationRadius)
% 
% Quick and accurate registration of highly-similar images using the Phase Correlation algorithm.
% Only translation (not rotation or distortion) is considered.
% https://en.wikipedia.org/wiki/Phase_correlation
% 
% 
% 'delta' is the [row, column] displacement of image2 relative to image1. This function has 
% 	sub-pixel resolution, so 'delta' are not necessarily integers. 
% 
% 'confidence' is a measure of the quality of the algorithm's final result.
% Confidence decreases with increasing image noise or dis-similarity. 
% 
% 'expectationRadius' provides a maximum expected radius for 'delta'. The default is 100.

% default
if nargin<3
	expectationR = 100;
end

% Take FFT of each image
F1 = fft2(image1);
F2 = fft2(image2);

% Create phase difference matrix
pdm = exp(1i*(angle(F1)-angle(F2)));
% Solve for phase correlation function
pcf = real(ifft2(pdm));
pcf = fftshift(pcf);

% Set the bright center pixel to be the average of its neighbors
center = size(pcf)/2 + 1/2; % Image centroid is here
cPix = ceil(center); % Center pixel is here
pcf(cPix(1), cPix(2)) = 0;
reg = pcf((cPix(1)-1):(cPix(1)+1), (cPix(2)-1):(cPix(2)+1));
pcf(cPix(1), cPix(2)) = sum(reg(:))./8;

[r,c] = meshgrid(1:size(pcf,1), 1:size(pcf,2));
mask = sqrt((r-size(pcf,1)/2).^2 + (c-size(pcf,2)/2).^2) > expectationR;
pcf(mask) = 0;

[q, idx] = max(pcf(:));
[r, c] = ind2sub(size(pcf),idx);

roi = pcf(r-5:r+5, c-5:c+5);
P = peakfit2d(roi);

v = P - ((size(roi)/2) + 1/2) + [r c];
delta = v - center;