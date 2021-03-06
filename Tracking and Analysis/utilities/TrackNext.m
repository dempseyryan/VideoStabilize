function [NewPoints, removedPtNum, keepAskingBoolean] = TrackNext(img,ROIsize,TrackPoints,remPoints, maxTravel, increaseROINum, soundOption)
%TrackNext Tracks points selected in SelectPoints for a different image
%   TrackNext(img,TrackPoints). img: image to find points in, TrackPoints:
%   points selected previously.
%%%%%%%Faster to crop image in here, then send to estimate centroid?
if remPoints == 0
    keepAskingBoolean = true;
else
    keepAskingBoolean = false;
end

NewPoints = zeros(size(TrackPoints, 1), 2); % pre-sizing to increase computation speed
removedPtNum = 0;
for i = 1:size(TrackPoints,1)           %for each point in the list of points to track
    [px, py] = EstimateCentroid(TrackPoints(i,1),TrackPoints(i,2),ROIsize,ROIsize,img);
    b=0;
    if increaseROINum ~= 0
    while (px == 0) && (py == 0) && b<3   %if the point can't be found, increase the ROI and search again
%         ROIsize = ROIsize+5;
        ROIsize = ROIsize + increaseROINum/3;
        b=b+1;
        [px, py] = EstimateCentroid(TrackPoints(i,1),TrackPoints(i,2),ROIsize,ROIsize,img,b);
        fprintf('Can''t find point #%s. Trying again.\n',num2str(i));
    end
    end
    
    %     if (sqrt(((abs(TrackPoints(i,1)-px))^2 + (abs(TrackPoints(i,2)-py))^2))>MaxTravel) && ~(px == 0) && ~(py ==0)
    %
    %         px = mean([TrackPoints(i,1) px]);
    %         py = mean([TrackPoints(i,2) py]);
    %         fprintf('Max at pt %s. Difference X: %s. Difference Y: %s\n',num2str(i),num2str(px-TrackPoints(i,1)),num2str(py-TrackPoints(i,2)));
    %     end
    
    if (px == 0) || (py == 0) || sqrt(((abs(TrackPoints(i,1)-px))^2 + (abs(TrackPoints(i,2)-py))^2))>maxTravel %if it cant find it, or if it deviates too much in one step
        
        if (sqrt(((abs(TrackPoints(i,1)-px))^2 + (abs(TrackPoints(i,2)-py))^2))>maxTravel) && ~(px == 0) &&~(py ==0)
            fprintf('Max travel reached: %s.\n',num2str(sqrt(((abs(TrackPoints(i,1)-px))^2 + (abs(TrackPoints(i,2)-py))^2))));
        end
        if remPoints == 1
            px = Inf;
            py = Inf;
            removedPtNum = removedPtNum + 1;
        else
            
            validInput = false;
            while validInput == false
                reselectBool = false;
                
                try
                    str = sprintf('Draw an ROI around point # %s.\n',num2str(i));
                    userCent2 = figure(3);
                    userCent2.WindowState = 'maximized';
                    if soundOption
                       beep on;
                       beep
                    end
                    [cpx, cpy, cpl, cph] = Helper(TrackPoints,img,ROIsize,i);
                    title(str);
                    rect = getrect(userCent2);
                    px = rect(1)+0.5*(rect(3))+cpx;%+NewPoints(i,1)-25;
                    py = rect(2)+0.5*(rect(4))+cpy;%+NewPoints(i,2)-25;
                    %fprintf('Point: X: %s Y: %s\n',num2str(px),num2str(py));
                    userCent2.delete;
                    validInput = true;
                catch
                    validInput = false;
                    deletePointBool = questdlg('The point was not selected', 'User canceled point', 'Reselect point', 'Delete point', 'Delete all troublesome points and stop asking', 'Reselect point');
                    if strcmp(deletePointBool, 'Delete point')% if the point is very troublesome, perhaps ignore it going forward                        
                        tempx = px;
                        tempy = py;
                        px = Inf;
                        py = Inf;
                        validInput = true;
                    elseif strcmp(deletePointBool, 'Delete all troublesome points and stop asking')
                        px = Inf;
                        py = Inf;
                        keepAskingBoolean = false;
                    else
                       reselectBool = true; 
                    end
                end
                if ~reselectBool && (isinf(px) || isinf(py)) % if not about to reselect, and pts were chosen to delete
                    answer = questdlg('Are you sure you would like to delete this point?', 'Delete point permanently?', 'Keep', 'Delete', 'Keep');
                    if ~strcmp(answer,'Delete')%if not following thru, recover
                        px = tempx;
                        py = tempy;
                    end
                elseif ~reselectBool && validInput == true%if not about to reselect, and point selected
                    answer = questdlg('Keep selected point?', 'Keep manual pt?', 'Keep', 'Delete', 'Keep');
                    if strcmp(answer,'Delete')
                        tempx = px;
                        tempy = py;
                        px = Inf;
                        py = Inf;
                    
                    dblCheck = questdlg('Are you sure you would like to delete this point?', 'Delete point permanently?', 'Keep', 'Delete', 'Keep');
                    if ~strcmp(dblCheck, 'Delete')
                       px = tempx;
                       py = tempy;
                    end
                    end
                end
            end
            
        end
        
        
    end
    
    NewPoints(i,:) = [px py];
end


%Double Check that the point can be found
% for i = 1:size(NewPoints,1);
%
%     [px py] = EstimateCentroid(NewPoints(i,1),NewPoints(i,2),ROIsize,ROIsize,img);
%
%     if abs(px-NewPoints(i,1))>=5 || abs(py-NewPoints(i,2))>=5 %if they're not close, leave them as is
%         fprintf('Point # %s may be unstable.\n',num2str(i));
%     elseif     abs(px-NewPoints(i,1))<5 && abs(py-NewPoints(i,2))<5 %if they're close, save the double checked version
%         NewPoints(i,:) = [px py];
%     end
% end
