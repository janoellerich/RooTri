%..........................................................................
%                    Example Application of contourc
%
%        by Jan Oellerich & Keno Jann Buescher & Jan Philip Degel
%                                2023
%..........................................................................

clc 
close all
clear

l = 25;
n = 50;

% define vectors x and y
x = linspace(-l,l,n);
y = linspace(-l,l,n);

% build mesh grid
[X,Y] = meshgrid(linspace(-l,l,n));

% generate matrix
Z = sin(pi * X / 8) + cos(pi * Y / 8) + 0.1;

% perform contourc function
P1 = contourc(x,y,Z,[0,0]);

plot(P1(1,:),P1(2,:),'o','MarkerSize',2)
axis equal
xlabel('x')
ylabel('y')
