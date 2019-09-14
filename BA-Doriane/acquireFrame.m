
function [pointCloud, colorImage, depthImage] = acquireFrame(colorDevice,depthDevice)
  
delete(imaqfind);	
colorImage = step(colorDevice);
depthImage = step(depthDevice);

%Extract the point cloud
pointCloud = pcfromkinect(depthDevice,depthImage,colorImage);
   
end

