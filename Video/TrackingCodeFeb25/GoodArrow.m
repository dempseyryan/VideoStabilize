function [Tx,Ty] = GoodArrow(xt1,yt1,xt2,yt2,col)
%GoodArrow Takes in two points and returns X and Y coordinates of the
%arrowhead tails. Connecting the result to the second point of the input
%will draw an arrowhead
%   xt1, yt1: coordinates for first point
%   xt2, yt2: coordinates for second point

angAt = atan((yt2-yt1)/(xt2-xt1));
angT = 30;

% Finding length between two given points 

P1=[xt1,yt1];P2=[xt2,yt2];
R=sqrt((xt2-xt1)^2+(yt2-yt1)^2);

%Find poins for arrow if it was just horizontal, but same size R
if xt1 > xt2 
    angAt = angAt+pi;
end

x1 = 0;
y1 = 0;
y2 = 0;
x2 = R;
angA = 0;

%scaling length to 75%
RS=0.75*R;

%Finding point C - corresponding to 0.75 length of vector between P1 and P2
Cx=x1+RS*cosd(angA);
Cy=y1+RS*sind(angA);

%Finding B, corresponding to length from C to P2
B=0.25*R;

%Finding A, corresponding to length from C to unkown point T1
A=B*tand(angT);

%Finding unknown points T1 and T2
Tx1=Cx-A*cosd(90-angA);%angA is always 0. not sure why
Ty1=Cy+A*sind(90-angA);

Tx2=Cx+A*sind(angA);
Ty2=Cy-A*cosd(angA);

%transform these horizontal arrow points to match the actual arrow, rotated
%about its first point

tf= [cos(angAt) sin(angAt) 0;
     -sin(angAt) cos(angAt) 0;
     0 0 1];

 tform = affine2d(tf);

[Tx,Ty] = transformPointsForward(tform,[Tx1;Tx2],[Ty1;Ty2]);
Tx = Tx+xt1;
Ty = Ty+yt1;
line([Tx(1) xt2],[Ty(1) yt2],'Color',col)
line([Tx(2) xt2],[Ty(2) yt2],'Color',col)
line([xt1 xt2],[yt1 yt2],'Color',col)
end

