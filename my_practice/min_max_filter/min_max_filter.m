original = imread("images\inputs\frame_0000.jpg");
% gs = im2gray(original);
% BW = imbinarize(gs);

bw2= im2bw(original,0.8);
% subplot(2,2,1),imshow(BW),title('imbinarize');
% subplot(2,2,2),imshow(bw2),title('im2bw');

minf=@(x) min(x(:));  %set 'min()' filter
maxf=@(x) max(x(:)); %set 'max()' filter
min_Image=nlfilter(BW,[3,3],minf); %Apply over 3x3 neighbourhood
max_Image=nlfilter(BW,[3,3],maxf); %Apply over 3x3 neighbourhood
subplot(2,2,1),imshow(BW),title('original');
subplot(2,2,2),imshow(min_Image),title('Min');
subplot(2,2,3),imshow(max_Image),title('Max');

