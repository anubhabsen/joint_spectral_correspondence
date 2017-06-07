I = imread('image.jpg') ;
I = single(vl_imdown(rgb2gray(I))) ;

binSize = 8;
magnif = 3;
Is = vl_imsmooth(I, sqrt((binSize/magnif)^2 - .25));

[f, d] = vl_dsift(Is, 'size', binSize);

N = size(f, 2);

weighted_graph(1:N, 1:N) = 0;

for i = 1:N
    for j = 1:N
        weighted_graph(i, j) = pdist(transpose(horzcat(d(:, i), d(:, j))));
    end
end

D(1:N, 1:N) = 0;

for i = 1:N
    sum = 0;
    for j = 1:N
        sum = sum + weighted_graph(i, j);
    end
    D(i, i) = sum;
end

% I = forgot how to incidence matrix

L = I - D^(-1/2) * weighted_graph * D^(-1/2);

% todo

L * U = lambda * U;
U_new = D^(-1/2) * U;