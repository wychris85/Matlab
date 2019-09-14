function visualiseCurrentCamera(handles)
IAMI = imaqhwinfo;
IA= char((IAMI.InstalledAdaptors));        
x= imaqhwinfo(IA);
     
try
    DeviceID= x.DeviceIDs{1};
    F = x.DeviceInfo(DeviceID).SupportedFormats;
    Format = char(F);
catch
    warndig({'Try Another Device or ID';...
        'You Don;;t have Installed this Device (VideoInputDevice)'})
    return
end

delete(imaqfind);
VidObj=videoinput(IA,DeviceID,Format);
handles.VidObj=VidObj;
VidRes = get(handles.VidObj,'videoResolution');
nBands = get(handles.VidObj,'NumberofBands');
axes(handles.axisAktuellesBild)
himage= image(zeros(VidRes(2),VidRes(1),nBands));
preview(handles.VidObj, himage)

end