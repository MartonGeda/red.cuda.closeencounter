%% Calculate angles of incidence from ellipses and from linear fitting of positions
d_calculate_trueanomaly;

alpha = zeros(N,1);
dydx1 = zeros(N,1);
dydx2 = zeros(N,1);

alphafit = zeros(N,1);
dydx1fit = zeros(N,2);
dydx2fit = zeros(N,2);

for i = 1:N
    if i == 1
        dydx1(1) = (oe1(pos(1),2) * sin(v1(pos(1))) * sin(v1(pos(1)) + oe1(pos(1),4)) + (1 + oe1(pos(1),2) * cos(v1(pos(1)))) * cos(v1(pos(1)) + oe1(pos(1),4))) / (oe1(pos(1),2) * sin(v1(pos(1))) * cos(v1(pos(1)) + oe1(pos(1),4)) - (1 + oe1(pos(1),2) * cos(v1(pos(1)))) * sin(v1(pos(1)) + oe1(pos(1),4)));
        dydx2(1) = (oe2(pos(1),2) * sin(v2(pos(1))) * sin(v2(pos(1)) + oe2(pos(1),4)) + (1 + oe2(pos(1),2) * cos(v2(pos(1)))) * cos(v2(pos(1)) + oe2(pos(1),4))) / (oe2(pos(1),2) * sin(v2(pos(1))) * cos(v2(pos(1)) + oe2(pos(1),4)) - (1 + oe2(pos(1),2) * cos(v2(pos(1)))) * sin(v2(pos(1)) + oe2(pos(1),4)));
        alpha(1) = acos(abs((1 + dydx1(1) * dydx2(1)) / sqrt((1 + dydx1(1)^2) * (1 + dydx2(1)^2)))) * 180/pi;
        
%         dydx1fit(1,1:2) = polyfit(phase1(1:pos(1),1),phase1(1:pos(1),2),1);
%         dydx2fit(1,1:2) = polyfit(phase2(1:pos(1),1),phase2(1:pos(1),2),1);
%         alphafit(1) = acos( abs((1 + dydx1fit(1,1) * dydx2fit(1,1)) / sqrt((1 + dydx1fit(1,1)^2) * (1 + dydx2fit(1,1)^2)))) * 180/pi;
        
    else
        dydx1(i) = (oe1(pos(i-1)+1,2) * sin(v1(pos(i-1)+1)) * sin(v1(pos(i-1)+1) + oe1(pos(i-1)+1,4)) + (1 + oe1(pos(i-1)+1,2) * cos(v1(pos(i-1)+1))) * cos(v1(pos(i-1)+1) + oe1(pos(i-1)+1,4))) / (oe1(pos(i-1)+1,2) * sin(v1(pos(i-1)+1)) * cos(v1(pos(i-1)+1) + oe1(pos(i-1)+1,4)) - (1 + oe1(pos(i-1)+1,2) * cos(v1(pos(i-1)+1))) * sin(v1(pos(i-1)+1) + oe1(pos(i-1)+1,4)));
        dydx2(i) = (oe2(pos(i-1)+1,2) * sin(v2(pos(i-1)+1)) * sin(v2(pos(i-1)+1) + oe2(pos(i-1)+1,4)) + (1 + oe2(pos(i-1)+1,2) * cos(v2(pos(i-1)+1))) * cos(v2(pos(i-1)+1) + oe2(pos(i-1)+1,4))) / (oe2(pos(i-1)+1,2) * sin(v2(pos(i-1)+1)) * cos(v2(pos(i-1)+1) + oe2(pos(i-1)+1,4)) - (1 + oe2(pos(i-1)+1,2) * cos(v2(pos(i-1)+1))) * sin(v2(pos(i-1)+1) + oe2(pos(i-1)+1,4)));
        alpha(i) = acos(abs((1 + dydx1(i) * dydx2(i)) / sqrt((1 + dydx1(i)^2) * (1 + dydx2(i)^2)))) * 180/pi;
        
        %if u == 0 && w == 0, then dydx = inf
        
%         dydx1fit(i,1:2) = polyfit(phase1(pos(i-1)+1:pos(i),1),phase1(pos(i-1)+1:pos(i),2),1);
%         dydx2fit(i,1:2) = polyfit(phase2(pos(i-1)+1:pos(i),1),phase2(pos(i-1)+1:pos(i),2),1);
%         alphafit(i) = acos(abs((1 + dydx1fit(i,1) * dydx2fit(i,1)) / sqrt((1 + dydx1fit(i,1)^2) * (1 + dydx2fit(i,1)^2)))) * 180/pi;
  
    end
end

%plot(Cf,abs(alpha - alphafit),'*')
%hist(alpha,20)