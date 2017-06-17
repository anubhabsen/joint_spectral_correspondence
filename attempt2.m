clear 
close all;

run('vlfeat-0.9.20/toolbox/vl_setup.m');

im1 = imread('21.jpg');
im2 = imread('22.jpg');

im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

im1 = im2single(im1);
im2 = im2single(im2);

[p1,d1] = vl_dsift(im1,'step',10,'size',12);
[p2,d2] = vl_dsift(im2,'step',10,'size',12);

disp('dsift done');

X = double([d1,d2]'+1);

N1 = size(d1,2);
N2 = size(d2,2);
N = N1 + N2;

W = pdist2(X,X,'cosine');

disp('pdist done');

D = zeros(N,N);

for i = 1:N
    sum = 0;
    for j = 1:N
        sum = sum + W(j, i);
    end
    D(i, i) = sum;
end

D_cap = D^(-1/2);
L = eye(N) - D_cap * W * D_cap;

disp('laplacian done');

k = 5;
[V,Diago] = eigs(L,k);
V1 = V(1:N1,:);
V2 = V(N1+1:N1+N2,:);

[X1,Y1] = meshgrid(1:size(im1,2),1:size(im1,1));
[X2,Y2] = meshgrid(1:size(im2,2),1:size(im2,1));

disp('eigs done');

for i=1:k - 1
	out1{i} = griddata(p1(1,:)',p1(2,:)',abs(V1(:,i + 1)),X1,Y1);
	out2{i} = griddata(p2(1,:)',p2(2,:)',abs(V2(:,i + 1)),X2,Y2);
    disp('Image done for');
    disp(i);
end

for i=1:4
    figure
    subplot(1,2,1),imagesc(out1{i}),colormap jet
    title(strcat('eigenvector',int2str(i+1)));
    subplot(1,2,2),imagesc(out2{i}),colormap jet
end