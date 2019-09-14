
function [validPointCloud_ds,X,C] = Filter(pointCloud,Gridstep,EdgesX)
 
% Noisereduktion
pointCloud_denoised = pcdenoise(pointCloud);

% Remove points with NaN and Inf values from the point cloud.
validPointCloud = removeInvalidPoints(pointCloud_denoised);

% Downsamplen
Gridstep =0.001;
validPointCloud_ds = pcdownsample(validPointCloud, 'gridAverage',Gridstep);
X = validPointCloud_ds.Location (:,[1 2 3]);
C             = double(validPointCloud_ds.Color) / 255.0; 

% 3-D Raum eingrenzen 
 EdgesX = [-0.5 0.5;-0.5 0.5;-0.5 0.5];
 
end