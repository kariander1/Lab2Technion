A= xlsread('hara.xlsx');

cmd = A(:,3);
hren = abs(fft(cmd))
plot(hren)
[a b ] = findpeaks(cmd)
figure;
plot(cmd); hold on;
plot(b,cmd(b),'or');
data = diff(A(b,2));
data2 = [data(2:end) data(1:end-1)];
alpha = 0.3;
data3 = sum(bsxfun(@times,data2,[alpha 1-alpha])')';
figure; plot(1./data3)