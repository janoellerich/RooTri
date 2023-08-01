%..........................................................................
%                    Example Application of RooTri
%
%        by Jan Oellerich & Keno Jann Buescher & Jan Philip Degel
%                                2023
%..........................................................................

clc
clear
close all

% --- load RooTriExample.txt file as point cloud
P = readmatrix('RooTriExample.txt');

% --- define plane parameters
a = 0.50;   b = 0.20;    
c = 0.40;   d = 0.30;

% --- run RooTri()
ipmat = RooTri(P,a,b,c,d);

% --- plot results
scatter3(ipmat(:,1),ipmat(:,2),ipmat(:,3),1,'k')
axis equal
title('Intersection points')
xlabel('x'); ylabel('y'); zlabel('z')



