%robert edges
I = imread('..\images\inputs\frame_0000.jpg');
gs = rgb2gray (I);

F = edge(gs, "roberts");

figure; imshow(I); title('Original Image');
figure; imshow(gs); title('Gray Image');
figure; imshow(F); title('Detected Edges');


