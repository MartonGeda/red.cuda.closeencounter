%% Cf histogram

cfmax = ceil(max(cf));
range = 0.2;


bin = range/2:range:cfmax-range/2;
figure('Name','CfHist','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
[n, xout] = hist(Cf,bin);
idx = xout < 1;
bar(xout,n,'hist'); hold on;
bar(xout(idx), n(idx),'BarWidth',1,'FaceColor','r');
title('Histogram of close encounters');
xlabel('radii enhance factor');
ylabel('number of close encounters');
axis([-1 cfmax+1 0 max(n)+1]);
legend(int2str(sum(n) - sum(n(idx))),int2str(sum(n(idx))));