samples = 91;
x = 1:.1:10;
noise = 0.1*randn(samples,1);
y = sin(x) + noise';
z = sin(x);
plot(y);

hold all;

fourier = fftshift(fft(y));
figure, plot(x,abs(fourier),'r');

y1 = y + z;

plot(y1, 'r');