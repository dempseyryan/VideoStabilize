function ShowPoints(PrevPts,img,ROIsize,p)
 
%load('PrevPoints.mat');
gPoints = zeros(1,size(PrevPts,1));
for i = 1:size(PrevPts,1)
    for u = 1:size(p,2)
        if i == p(1,u)
           gPoints(1,i) = 1;
        end
    end
end
l = range(PrevPts(:,1))+100;
h = range(PrevPts(:,2))+100;
imshow(img);
for i = 1:size(PrevPts,1)
    x = PrevPts(i,1);
    y = PrevPts(i,2);
    hold on;
    if gPoints(1,i) == 1
        col = 'green';
    else
        col = 'red';
    end
if isfinite(x) && isfinite(y)
    if x-0.5*ROIsize < 0
        offsetx = 0;
    else offsetx = x-0.5*ROIsize;
    end
    if y-0.5*ROIsize < 0
        offsety = 0;
    else offsety = y-0.5*ROIsize;
    end
    rectangle('Position',[offsetx offsety ROIsize ROIsize], 'EdgeColor',col);
    t = sprintf('%s',num2str(i));
    text(offsetx,offsety,t,'Color',col,'FontSize',ROIsize/2);  %give point a number
end
end
