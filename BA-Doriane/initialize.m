
function initialize(handles,number)
    [colorDevice,depthDevice] = initKinect();
    Data.CurrentImg = number;
    Data.colorDevice = colorDevice;
    Data.depthDevice = depthDevice;
    handles.figure1.UserData = Data;
    visualiseCurrentCamera(handles); 
end