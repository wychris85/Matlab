

function planes=doFitPlane(ptCloud,maxDistance,referenceVector,maxAngularDistance)

planes = {};
remainPtCloud=null;
roiIndices = null;
counter = 1;
while (true)
    
    if(counter== 1)
        [~,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);
        plane = select(ptCloud,inlierIndices);
        if(size(plane) == 0)
            break;
        end
        remainPtCloud = select(ptCloud,outlierIndices);
        planes(counter) = plane;
    else
        [~,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud,maxDistance,'roiIndices',roiIndices);
        plane = select(remainPtCloud,inlierIndices);
        if(size(plane) == 0)
            break;
        end
        remainPtCloud = select(remainPtCloud,outlierIndices);
        planes(counter) = plane;
    end
    
    roi = [-inf,inf;-2.6,inf;-inf,inf];
    remainPtCloud = pcdenoise(remainPtCloud, 'NumNeighbors', 7, 'Threshold', 0.001);
    roiIndices = findPointsInROI(remainPtCloud,roi);
    counter = counter +1;
end

end