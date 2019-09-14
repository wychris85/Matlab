
function varargout = WolkenmacherMain(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WolkenmacherMain_OpeningFcn, ...
                   'gui_OutputFcn',  @WolkenmacherMain_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT
end 
% --- Executes just before WolkenmacherMain is made visible.
function WolkenmacherMain_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for WolkenmacherMain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
initialize(handles,0);

end

% --- Outputs from this function are returned to the command line.
function varargout = WolkenmacherMain_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in TakeImages.
function TakeImages_Callback(hObject, eventdata, handles)

TakeImage(handles,hObject)

end 

function buttonBildVorher_Callback(~, eventdata, handles)

Data = handles.figure1.UserData;
  if(Data.CurrentImg > 0)
Data.CurrentImg = Data.CurrentImg - 1;
handles.figure1.UserData = Data;
displayImageNumber(handles,Data.CurrentImg)
   end
  
end

% --- Executes on button press in buttonBildNachher.
function buttonBildNachher_Callback(hObject, eventdata, handles)
  
Data = handles.figure1.UserData;
  if (Data.CurrentImg < length(handles.savePhotoTemp))
Data.CurrentImg = Data.CurrentImg + 1;
handles.figure1.UserData = Data;
displayImageNumber(handles,Data.CurrentImg)
  end 
    
end

% --- Executes on button press in SaveImages.
function SaveImages_Callback(~, ~, handles)

phototosavetemp = handles.savePhotoTemp;
save('photo2.mat','phototosavetemp')

end

% --- Executes on button press in load.
function load_Callback(~, ~, handles)

filename='photo2.mat';
loadedData=load(filename);
loadedPhoto = loadedData.phototosavetemp;

for i = 1:length(loadedPhoto)
    try
 displayImageNumber(handles,i)
 visualizeCloud(handles,loadedPhoto(i).pCloud)
 n = 2;
 pause(n)
    catch
 warning('cloud data visualization nbr %i failed!',i)
    end 
   
  end
  
 disp('load fertig')

end

% --- Executes on button press in DeleteImage.
function DeleteImage_Callback(hObject, eventdata, handles)

field = str2num(handles.currentImageNumber.String);
handles.savePhotoTemp = deletePhoto (handles.savePhotoTemp, field);
guidata(hObject,handles)

end

% --- Executes on button press in Displayimage.
function Displayimage_Callback(hObject, eventdata, handles)

% load all the image
load('photo2.mat');

figure

% Display all the Images
for k = 1:length(phototosavetemp)
pCloudCurrent  = phototosavetemp(k);
subplot(5,8,k);
curImg = pCloudCurrent.pCloud.Color;
imshow(curImg);

end

end

% --- Executes on button press in Stitching.
function Stitching_Callback(hObject, eventdata, handles)

%load all the image
load('photo2.mat');


% Extraction for two consecutiv point clounds 
pCloudReference = phototosavetemp(1).pCloud;
pCloudCurrent = phototosavetemp(2).pCloud;
      
% point within each grid box are merged by averaging their locations,Colors, and normals
gridStep = 0.01;
fixe = pcdownsample(pCloudReference, 'gridAverage', gridStep);
move = pcdownsample(pCloudCurrent, 'gridAverage', gridStep);

% Align of two point clouds with ICP algorithm 
tform =pcregrigid(move, fixe, 'Metric','pointToPlane','Extrapolate', true);
ptCloudAligned = pctransform(pCloudCurrent,tform);

% create the world scene with the registered data and filter the overlapped region 
mergeStep = 0.015;
pointCloudScene = pcmerge(pCloudReference, ptCloudAligned, mergeStep);

% Visualize the First image.
figure
subplot(2,2,1)
imshow(pCloudReference.Color);
title('First Image')
drawnow

% Visualize the Second image.
subplot(2,2,3)
imshow(pCloudCurrent.Color);
title('Second Image')
drawnow

% Visualize the Scene of the two images.
subplot(2,2,[2,4]);
pcshow(pointCloudScene, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
title('Reconstruction of the two images')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')

%Stitch a Sequence of Point Clouds
% Store the transformation object that accumulates the transformation.
accumTform = tform; 
figure
hAxes = pcshow(pointCloudScene, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down');
title('Reconstruction');

% Set the axes property for faster rendering
hAxes.CameraViewAngleMode = 'auto';
hScatter = hAxes.Children;
 
 for i = 3:length(phototosavetemp)
 pCloudCurrent = phototosavetemp(i).pCloud;

% Moving point cloud become as reference.
fixe = move;
move = pcdownsample(pCloudCurrent, 'gridAverage', gridStep);

% Apply ICP registration.
tform = pcregistericp(move, fixe, 'Metric','pointToPlane','Extrapolate', true);

% Transform the current point cloud to the reference coordinate system
accumTform = affine3d(tform.T * accumTform.T);
ptCloudAligned = pctransform(pCloudCurrent, accumTform);

% Refresh the world scene.
pointCloudScene = pcmerge(pointCloudScene, ptCloudAligned, mergeStep);

% Visualize the world scene.
hScatter.XData = pointCloudScene.Location(:,1);
hScatter.YData = pointCloudScene.Location(:,2);
hScatter.ZData = pointCloudScene.Location(:,3);
hScatter.CData = pointCloudScene.Color;
drawnow

 end
 
pcshow(pointCloudScene, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down', ...
        'Parent', hAxes)
title('Refresh the Scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')

roi = [-inf,inf;-inf,inf;-inf,inf];
Indices = findPointsInROI(pointCloudScene,roi);
pointCloudScene = select(pointCloudScene,Indices);
pointCloudScene = pcdenoise(pointCloudScene); 
figure;
pcshow(pointCloudScene);
title('Denoised Scene');

handles.pointCloudScene = pointCloudScene;
guidata(hObject,handles)

end



% --- Executes on button press in findspace.
function findspace_Callback(hObject, eventdata, handles)

if (~isfield(handles,'pointCloudScene'))
   msgbox('Please first perform Stitching');
else
    
pointCloudScene = handles.pointCloudScene;
pc = pointCloudScene;

% Remove points with NaN and Inf values from the pointcloudscene
pc = removeInvalidPoints(pc);

% Select Pointcloud area
roi = [-4,4; -5,9; -5, 8];
Indices = findPointsInROI(pc,roi);
pc = select(pc,Indices);


% show the Pointcloud
figure
pcshow(pc)
xlabel('X(m)')
ylabel('Y(m)')
zlabel('Z(m)')
title('Original Point Cloud')



% Fitting level1,
[model1, in, out] = pcfitplane(pc, 0.01,[0,1,0],5);
plane1 = select(pc, in);
pcR = select(pc, out); 
pcshow(plane1)
        


% Fitting level2.
[model2,in,out] = pcfitplane(pcR,0.01,0.05,[0 1 0]);
plane2 = select(pcR,in);
pcR = select(pcR,out);
pcshow(plane2)


% Fitting level3.
[model3,in,out] = pcfitplane(pcR,0.01,0.05,[0 1 0]);
plane3 = select(pcR,in);
pcR = select(pcR,out);
fitPlane(pcR.Location, plane3);
pcshow(plane3)

end
end


% --- Executes on button press in Projection.
function Projection_Callback(hObject, eventdata, handles)



end

function currentImageNumber_Callback(hObject, eventdata, handles)
% hObject    handle to currentImageNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentImageNumber as text
%        str2double(get(hObject,'String')) returns contents of currentImageNumber as a double

end

% --- Executes during object creation, after setting all properties.
function currentImageNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentImageNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)

msgbox('Thanks for using Image processing tool')
pause(1)
close();
close();
end
