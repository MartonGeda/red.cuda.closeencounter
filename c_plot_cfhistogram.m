%% Cf histogram
Cf = zeros(N,1);

for i = 1:N
   if (i == 1)
      Cf(1) = min(cf(1:pos(1)));
   else
      Cf(i) = min(cf((pos(i-1)+1):pos(i)));
   end
end

cfmax = ceil(max(cf));
range = 0.25;


bin = 0:range:cfmax;
figure();
[n, xout] = hist(Cf,bin);
idx = xout < 1;
bar(xout,n,'hist'); hold on;
bar(xout(idx), n(idx),'BarWidth',1,'FaceColor','r');
title('Histogram of close encounters');
xlabel('radii enhance factor');
ylabel('number of close encounters');
legend(int2str(sum(n) - sum(n(idx))),int2str(sum(n(idx))), int2str(sum(n(idx))/(sum(n) - sum(n(idx)))))