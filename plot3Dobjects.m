figure
[X,Y] = meshgrid(-5:.5:5);
Z = X;
s = surf(X,Y,Z,'FaceAlpha',0.5);
xlabel('x')
ylabel('y')
zlabel('z')
%% Y
hold on
Z = zeros(size(X));
s = surf(X,Y,Z,'FaceAlpha',0.5);
%% X
figure

Z = zeros(size(X));
s = surf(X,Y,Z,'FaceAlpha',0.5);
hold on
s = surf(X,Z,Y,'FaceAlpha',0.5);
s = surf(Z,Y,X,'FaceAlpha',0.5);

%%

figure
ax = axes;
hold on
ax.XLim = [-5 5];
ax.YLim = [-5 5];
ax.ZLim = [-5 5];
% ax.Color = [0 0 0];
% 
% [X,Y] = meshgrid(-5:.5:5);
% Z = zeros(size(X));

% s = surf(X,Y,Z,'FaceAlpha',0.2,'FaceColor','#4DBEEE');
hold on
% s = surf(X,Z,Y,'FaceAlpha',0.2,'FaceColor','#4DBEEE');
% s = surf(Z,Y,X,'FaceAlpha',0.2,'FaceColor','#4DBEEE');
grid on
% cube '#A2142F'
cubeProps = {'FaceAlpha',0.6,'FaceColor','#FF0000','EdgeColor','none'};
A = [-1*eye(3);eye(3)];

[X,Y] = meshgrid(-1:.1:1);
Z = zeros(size(X))+1;
s = surf(X,Y,Z,cubeProps{:});
s = surf(X,Z,Y,cubeProps{:});
s = surf(Z,Y,X,cubeProps{:});
Z = zeros(size(X))-1;
s = surf(X,Y,Z,cubeProps{:});
s = surf(X,Z,Y,cubeProps{:});
s = surf(Z,Y,X,cubeProps{:});

%%
%[0.9 0.3 0.1]  [1]
[X,Y] = meshgrid(-5:.5:1,-5:.5:5);
Z = zeros(size(X));
surf(X,Y,Z,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);

[X,Y] = meshgrid(-5:.5:0.1,-5:.5:5);
Z = 1 + zeros(size(X))+0.1.*X;
surf(X,Y,Z,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);


[X,Y] = meshgrid(-5:.5:0.1,-5:.5:5);
Z = 1 + zeros(size(X))+0.1.*X;
surf(X,Z,Y,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);

[X,Y] = meshgrid(-5:.5:0.4,-5:.5:5);
Z = 1 + zeros(size(X))+0.87.*X;
surf(X,Z,Y,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);


%%
%[0.9 0.3 0.1]  [1]
figure
[X,Y] = meshgrid(-5:.5:5);
Z = zeros(size(X));
surf(X,Y,Z,cubeProps{:});
hold on;
% [X,Y] = meshgrid(-5:.5:5);
% s = surf(X,Y,X,'FaceAlpha',0.4);
%%
[X,Y] = meshgrid(-5:.5:5);
[xX,yY] = meshgrid(-5:.3:1);
s = surf(X,Y,xX,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);


%% ALPHA SHAPE
% alphaShapes
% https://se.mathworks.com/help/matlab/ref/alphashape.html
% conv hulls boundaries:
% https://se.mathworks.com/help/matlab/math/types-of-region-boundaries.html
figure('WindowStyle','docked')

A = [-1*eye(3);eye(3)];
b = ones(6,1);
plot3(A(:,1),A(:,2),A(:,3),'.')
hold on
shp = alphaShape(A,1);
shp1 = plot(shp);
shp1.FaceAlpha = 0.3;
%% add one row
A = [A; 0.3 0.4 0.5];
shp2 = alphaShape(A,1);
s = plot(shp2);
s.FaceAlpha = 0.3;
axis equal
%%
A = [A; -0.3 0.1 0.1];
p = plot3(-0.3, 0.1, 0.1,'r*');
shp2 = alphaShape(A,1);
s = plot(shp2);
s.FaceAlpha = 0.3;
axis equal


%% cool sphere
[x1,y1,z1] = sphere(24);
x1 = x1(:);
y1 = y1(:);
z1 = z1(:);
x2 = x1+5;
[x3,y3,z3] = sphere(5);
x3 = x3(:)+5;
y3 = y3(:);
z3 = z3(:)+25;
P = [x1 y1 z1; x2 y1 z1; 0.25*x3 0.25*y3 0.25*z3];
P = unique(P,'rows');
plot3(P(:,1),P(:,2),P(:,3),'.')
axis equal
grid on