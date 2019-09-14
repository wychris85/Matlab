 function visualizeCloud(handles,  pointCloud)

angle = -pi/2;
pointCloud= pctransform(pointCloud, affine3d([1 0 0 0;0, cos(angle), sin(angle), 0;0, -sin(angle), cos(angle), 0; 0 0 0 1])); 
pointCloudF= findPointsInROI( pointCloud, [-inf,inf;-inf,inf;-inf,inf]);
pointCloud= select(pointCloud, pointCloudF);
gridStep = 0.001;
pointcloud = pcdownsample(pointCloud,'gridAverage',gridStep);
X = pointCloud.Location (:,1);
Y = pointCloud.Location (:,2);
Z = pointCloud.Location (:,3);
C = single(pointCloud.Color)/255;
scatter3(handles.axisPunktwolke, X, Y, Z, 3, C);

 end
 
 