I1 = single(rgb2gray(imread('1.jpg')));
I2 = single(rgb2gray(imread('2.jpg')));
%I = single(vl_imdown(rgb2gray(I))) ;

binSize = 16;
magnif = 3;
Is1 = vl_imsmooth(I1, sqrt((binSize/magnif)^2 - .25));
Is2 = vl_imsmooth(I2, sqrt((binSize/magnif)^2 - .25));

[f1, d1] = vl_dsift(Is1, 'size', binSize);
[f2, d2] = vl_dsift(Is2, 'size', binSize);

N1 = size(f1, 2);
N2 = size(f2, 2);
N = N1 + N2;

d = double(horzcat(d1, d2));

weighted_graph = pdist2(d', d', 'cosine');

D = zeros(N,N);

for i = 1:N
    disp(i);
    sum = 0;
    for j = 1:N
        sum = sum + weighted_graph(i, j);
    end
    D(i, i) = sum;
end

% I = forgot how to incidence matrix

% L = I - D^(-1/2) * weighted_graph * D^(-1/2);
L = D^(-1/2) * (D - weighted_graph) * D^(-1/2);

eigmatrix1 = zeros(size(I1));
eigmatrix2 = zeros(size(I2));

zerocells1 = zeros(2,prod(size(eigmatrix1)) - length(f1));
zerocells2 = zeros(2,prod(size(eigmatrix2)) - length(f2));

count1 = 1;
count2 = 1;

for i = 1:size(eigmatrix1,1)
    for j = 1:size(eigmatrix1,2)
        if eigmatrix1(i,j) == 0
            zerocells1(:, count1) = [i;j];
            count1 = count1 + 1;
        end
    end
end

for i = 1:size(eigmatrix2,1)
    for j = 1:size(eigmatrix2,2)
        if eigmatrix2(i,j) == 0
            zerocells1(:, count2) = [i;j];
            count2 = count2 + 1;
        end
    end
end

[eV, eD] = eig(L);
col = 2;

plot(ev(col, 2));

for i = 1:length(D)
%     disp(i);
    if i <= length(f1)
        eigmatrix1(f1(1,i), f1(2,i)) = eV(i,col);
    else
        eigmatrix2(f2(1,i-length(f1)), f2(2,i-length(f1))) = eV(i,col);
    end
end

final1 = interp2(eigmatrix1, zerocells1(1,:), zerocells1(2,:));
final2 = interp2(eigmatrix2, zerocells2(1,:), zerocells2(2,:));

for i = 1:length(zerocells1)
    eigmatrix1(zerocells1(1,i), zerocells1(2,i)) = final1(i);
end

for i = 1:length(zerocells2)
    eigmatrix2(zerocells2(1,i),zerocells2(2,i)) = final2(i);
end

figure
subplot(1,2,1);
imshow(eigmatrix1);
% imshow(final1);
subplot(1,2,2);
% imshow(final2);
imshow(eigmatrix2);

% todo

%L * U = lambda * U;
%U_new = D^(-1/2) * U;