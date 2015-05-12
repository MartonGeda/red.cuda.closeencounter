%% Calculate angles of incidence from ellipses and from linear fitting of positions
d_calculate_trueanomaly;

alpha = zeros(N,1);
dydx1 = zeros(N,1);
dydx2 = zeros(N,1);

%alphafit = zeros(N,1);
%dydx1fit = zeros(N,2);
%dydx2fit = zeros(N,2);

for i = 1:N
   if i == 1
      ii = 1;
      %figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
   else
      ii = pos(i-1)+1;    
   end 
   
%         dydx1(1) = (oe1(pos(1),2) * sin(v1(pos(1))) * sin(v1(pos(1)) + oe1(pos(1),4)) + (1 + oe1(pos(1),2) * cos(v1(pos(1)))) * cos(v1(pos(1)) + oe1(pos(1),4))) / (oe1(pos(1),2) * sin(v1(pos(1))) * cos(v1(pos(1)) + oe1(pos(1),4)) - (1 + oe1(pos(1),2) * cos(v1(pos(1)))) * sin(v1(pos(1)) + oe1(pos(1),4)));
%         dydx2(1) = (oe2(pos(1),2) * sin(v2(pos(1))) * sin(v2(pos(1)) + oe2(pos(1),4)) + (1 + oe2(pos(1),2) * cos(v2(pos(1)))) * cos(v2(pos(1)) + oe2(pos(1),4))) / (oe2(pos(1),2) * sin(v2(pos(1))) * cos(v2(pos(1)) + oe2(pos(1),4)) - (1 + oe2(pos(1),2) * cos(v2(pos(1)))) * sin(v2(pos(1)) + oe2(pos(1),4)));
%         alpha(1) = acos(abs((1 + dydx1(1) * dydx2(1)) / sqrt((1 + dydx1(1)^2) * (1 + dydx2(1)^2)))) * 180/pi;
        
%         dydx1fit(1,1:2) = polyfit(phase1(1:pos(1),1),phase1(1:pos(1),2),1);
%         dydx2fit(1,1:2) = polyfit(phase2(1:pos(1),1),phase2(1:pos(1),2),1);
%         alphafit(1) = acos( abs((1 + dydx1fit(1,1) * dydx2fit(1,1)) / sqrt((1 + dydx1fit(1,1)^2) * (1 + dydx2fit(1,1)^2)))) * 180/pi;
        
%     else
        dydx1(i) = (oe1(ii(1),2) * sin(v1(ii(1))) * sin(v1(ii(1)) + oe1(ii(1),4)) + (1 + oe1(ii(1),2) * cos(v1(ii(1)))) * cos(v1(ii(1)) + oe1(ii(1),4))) / (oe1(ii(1),2) * sin(v1(ii(1))) * cos(v1(ii(1)) + oe1(ii(1),4)) - (1 + oe1(ii(1),2) * cos(v1(ii(1)))) * sin(v1(ii(1)) + oe1(ii(1),4)));
        dydx2(i) = (oe2(ii(1),2) * sin(v2(ii(1))) * sin(v2(ii(1)) + oe2(ii(1),4)) + (1 + oe2(ii(1),2) * cos(v2(ii(1)))) * cos(v2(ii(1)) + oe2(ii(1),4))) / (oe2(ii(1),2) * sin(v2(ii(1))) * cos(v2(ii(1)) + oe2(ii(1),4)) - (1 + oe2(ii(1),2) * cos(v2(ii(1)))) * sin(v2(ii(1)) + oe2(ii(1),4)));
        alpha(i) = acos(abs((1 + dydx1(i) * dydx2(i)) / sqrt((1 + dydx1(i)^2) * (1 + dydx2(i)^2)))) * 180/pi;
        
        %if u == 0 && w == 0, then dydx = inf
        
%         dydx1fit(i,1:2) = polyfit(phase1(pos(i-1)+1:pos(i),1),phase1(pos(i-1)+1:pos(i),2),1);
%         dydx2fit(i,1:2) = polyfit(phase2(pos(i-1)+1:pos(i),1),phase2(pos(i-1)+1:pos(i),2),1);
%         alphafit(i) = acos(abs((1 + dydx1fit(i,1) * dydx2fit(i,1)) / sqrt((1 + dydx1fit(i,1)^2) * (1 + dydx2fit(i,1)^2)))) * 180/pi;
  
%     end
end

%plot(Cf,abs(alpha - alphafit),'*')
%hist(alpha,20)

%%

d_calculate_trueanomaly;

alphafit = zeros(length(t),1);
dx1 = zeros(length(t)-1,1);
dx2 = zeros(length(t)-1,1);
dy1 = zeros(length(t)-1,1);
dy2 = zeros(length(t)-1,1);

for i = 1:size(alphafit,1)-1
    dx1(i) = phase1(i+1,1) - phase1(i,1);
    dx2(i) = phase2(i+1,1) - phase2(i,1);
    dy1(i) = phase1(i+1,2) - phase1(i,2);
    dy2(i) = phase2(i+1,2) - phase2(i,2);
    alphafit(i) =  acosd( abs( (dx1(i)*dx2(i) + dy1(i)*dy2(i)) / sqrt( (dx1(i)^2 + dy1(i)^2) * (dx2(i)^2 + dy2(i)^2) ) ) );
    if (alphafit(i) < 1e-3)
        alphafit(i) = 0;
    end
end

% alphafit(pos) = alphafit(pos-1);
alphafit(pos) = 0;

aa = alphafit;

da = [diff(alphafit); 0];
j = zeros(length(alphafit),1);

k = 1;
for i=1:length(alphafit)-1
   if (abs(da(i)) > 1.5*(alphafit(i) + alphafit(i+1)) / 2)
       if (da(i) > 0)
          %alphafit(i) = NaN; 
          j(k) = i;
          k = k+1;
       else
          %alphafit(i+1) = NaN; 
          j(k) = i+1;
          k = k+1;          
       end
    end
end

tmp = find(j == 0,1,'first') - 1;

j = j(1:tmp);

alphafit(j) = NaN;
alphafit(pos) = NaN;
alphafit(find(alphafit < 5e-3)) = NaN;

%alphafit = smooth(alphafit);
%da = [diff(alphafit); 0];
da = diff(alphafit);
%%

%dt = [diff(t); 0];
dt = diff(t);
tt = t(1:end-1) + dt./2;
ttt = 0:0.001:(t(pos(1)) - t(1));
%p = polyfit(t(~isnan(alphafit(1:pos(1)))) - t(1),alphafit(~isnan(alphafit(1:pos(1)))),20);

for i=1
   if i==1
      figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]); 
      plot(t(1:pos(1)) - t(1),alphafit(1:pos(1)),'*');
      %plot(t(1:pos(1)) - t(1),alphafit(1:pos(1)),'*',ttt,polyval(p,ttt),'*');
      set(gcf,'PaperPositionMode','auto');
      %print('-dpng',strcat('Angle',int2str(1)));
   else
      figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
      plot(t(pos(i-1)+1:pos(i)) - t(pos(i-1)+1),alphafit(pos(i-1)+1:pos(i)),'*');
      %plot(t(pos(i-1)+1:pos(i)) - t(pos(i-1)+1),smooth(alphafit(pos(i-1)+1:pos(i)),5,'rlowess'),'*');
      %plot(tt(pos(i-1)+1:pos(i)) - tt(pos(i-1)+1),da(pos(i-1)+1:pos(i))./dt(pos(i-1)+1:pos(i)),'*');
      set(gcf,'PaperPositionMode','auto');
      %print('-dpng',strcat('diffAngle',int2str(i)));
   end
end
