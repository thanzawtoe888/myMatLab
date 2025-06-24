I = imread('..\images\inputs\frame_0000.jpg');
N = imnoise(I,"salt & pepper", 0.08);
mf = ones(3,3)/9;  %define filter
noise_free = imfilter(N,mf);

subplot(2,2,1),imshow(I), title("Original Image");
subplot(2,2,2),imshow(N), title("Noisy Image");
subplot(2,2,3),imshow(noise_free), title("After Removing Noise")
