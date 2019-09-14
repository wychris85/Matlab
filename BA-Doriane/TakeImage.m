
function [pointCloud] = TakeImage(handles,hObject)
    
n = 10;
delete(imaqfind); 
[colorDevice,depthDevice] = initKinect();

for i = 1:n
    
pause(5);
[pointCloud, colorImage, depthImage] = acquireFrame(colorDevice,depthDevice);
% [pointCloud,X,C]= Filter(pointCloud,0.001);
handles.savePhotoTemp(i) = savePhoto(pointCloud, colorImage, depthImage);
handles.CurrentImg = i;
guidata(hObject,handles)
visualizeCloud(handles,pointCloud)
displayImageNumber(handles,i)
initialize(handles,i)
      
end
    
phototosavetemp = handles.savePhotoTemp;
save('photo4.mat','phototosavetemp')
 
end