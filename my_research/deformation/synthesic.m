% 1D signal
s1 = ones(64,1);
n_s1 = s1./sum(s1);

subplot(2,1,1); imshow (s1); title ("Original")
subplot(2,1,2); imshow (n_s1); title ("first convolution")