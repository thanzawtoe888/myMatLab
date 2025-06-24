clear all
cam = webcam();
cam.Resolution = '320x240';

h = figure;

while ishandle(h) 
    I = snapshot(cam);
    gs = rgb2gray(I);
    S = edge(gs, 'sobel');
    R = edge(gs, 'roberts');
    P = edge(gs, 'prewitt');

    subplot(2,2,1); imshow(I); title('Original Image');
    subplot(2,2,2); imshow(S); title('Sobel Edges');
    subplot(2,2,3); imshow(R); title('Roberts Edges');
    subplot(2,2,4); imshow(P); title('Prewitt Edges');

    drawnow
end


     
