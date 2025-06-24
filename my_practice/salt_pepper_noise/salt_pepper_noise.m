I = imread('..\images\inputs\frame_0000.jpg');
N = imnoise(I,"salt & pepper", 0.08);
imshow(N)