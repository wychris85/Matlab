
function [colorDevice,depthDevice] = initKinect()

delete(imaqfind);
colorDevice = imaq.VideoDevice('kinect',1);
depthDevice = imaq.VideoDevice('kinect',2);
    
% Initialize the cameras
step(colorDevice);
step(depthDevice);


end