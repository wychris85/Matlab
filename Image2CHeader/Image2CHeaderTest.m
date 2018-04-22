DestPath = 'F:\XilinxProj\HLS_Examples\HlsCoursesYoutube\Lab10\ConvErodeDilate';
I = imread('pout.tif');
integralI = integralImage(I);

% IOut = HistoStrech(I);
% % IOut is optional. If not provided, pass empty matrix [] 
% [IGray1, f] = Image2CHeader(I, [], DestPath, 'Pout', 0);

figure(1)
imshow(I);
figure(2)
imshow(uint8(integralI));