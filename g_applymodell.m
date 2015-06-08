%%
phase1tr = zeros(N,12);
phase2tr = zeros(N,12);

phase1an = zeros(N,6);
phase2an = zeros(N,6);

xtkpnew = zeros(N,1);
ytkpnew = zeros(N,1);
ztkpnew = zeros(N,1);

err = zeros(N,12);
ooe1 = zeros(N,6);
ooe2 = zeros(N,6);
oean1 = zeros(N,6);
oean2 = zeros(N,6);

dummy = zeros(N,12);

hiba = zeros(N,3);

for i=1:N
   if i == 1
      ii = 1:pos(1);
      %figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
   else
      ii = pos(i-1)+1:pos(i);    
   end
  
mu = gauss2 * (m1(ii(1)) + m2(ii(1)));

hiba(i,:) = [abs((vxtkp(ii(1)) - vxtkp(ii(end))) / vxtkp(ii(1))) , abs((vytkp(ii(1)) - vytkp(ii(end))) / vytkp(ii(1))), abs((vztkp(ii(1)) - vztkp(ii(end))) / vztkp(ii(1)))];
   
% Transform positions, velocities
phase1tr(i,1:6) = [phase1(ii(1),1) - xtkp(ii(1)), phase1(ii(1),2) - ytkp(ii(1)), phase1(ii(1),3) - ztkp(ii(1)), phase1(ii(1),4) - vxtkp(ii(1)), phase1(ii(1),5) - vytkp(ii(1)), phase1(ii(1),6) - vztkp(ii(1))];
phase2tr(i,1:6) = [phase2(ii(1),1) - xtkp(ii(1)), phase2(ii(1),2) - ytkp(ii(1)), phase2(ii(1),3) - ztkp(ii(1)), phase2(ii(1),4) - vxtkp(ii(1)), phase2(ii(1),5) - vytkp(ii(1)), phase2(ii(1),6) - vztkp(ii(1))];

% Calculate transformed positions, velocities at the end of the close encounter
[phase1tr(i,7),phase1tr(i,8),phase1tr(i,9),phase1tr(i,10),phase1tr(i,11),phase1tr(i,12)] = twobodyproblem(mu,phase1tr(i,1),phase1tr(i,2),phase1tr(i,3),phase1tr(i,4),phase1tr(i,5),phase1tr(i,6),0,timeofce(i));
[phase2tr(i,7),phase2tr(i,8),phase2tr(i,9),phase2tr(i,10),phase2tr(i,11),phase2tr(i,12)] = twobodyproblem(mu,phase2tr(i,1),phase2tr(i,2),phase2tr(i,3),phase2tr(i,4),phase2tr(i,5),phase2tr(i,6),0,timeofce(i));

% Calculate the new transformation vector
xtkpnew(i) = xtkp(ii(1)) + vxtkp(ii(1)) * timeofce(i);
ytkpnew(i) = ytkp(ii(1)) + vytkp(ii(1)) * timeofce(i);
ztkpnew(i) = ztkp(ii(1)) + vztkp(ii(1)) * timeofce(i);

phase1an(i,1:6) = [phase1tr(i,7) + xtkpnew(i), phase1tr(i,8) + ytkpnew(i), phase1tr(i,9) + ztkpnew(i), phase1tr(i,10) + vxtkp(ii(1)), phase1tr(i,11) + vytkp(ii(1)), phase1tr(i,12) + vztkp(ii(1))];
phase2an(i,1:6) = [phase2tr(i,7) + xtkpnew(i), phase2tr(i,8) + ytkpnew(i), phase2tr(i,9) + ztkpnew(i), phase2tr(i,10) + vxtkp(ii(1)), phase2tr(i,11) + vytkp(ii(1)), phase2tr(i,12) + vztkp(ii(1))];

err(i,:) = [ abs((phase1an(i,:) - phase1(ii(end),:)) ./ phase1(ii(end),:)), abs((phase2an(i,:) - phase2(ii(end),:)) ./ phase2(ii(end),:))];

[ooe1(i,1:6)] = phase2oe(mu1(1),phase1(ii(end),1),phase1(ii(end),2),phase1(ii(end),3),phase1(ii(end),4),phase1(ii(end),5),phase1(ii(end),6));
[ooe2(i,1:6)] = phase2oe(mu1(1),phase1(ii(end),1),phase1(ii(end),2),phase1(ii(end),3),phase1(ii(end),4),phase1(ii(end),5),phase1(ii(end),6));

[oean1(i,1:6)] = phase2oe(mu1(1),phase1an(i,1),phase1an(i,2),phase1an(i,3),phase1an(i,4),phase1an(i,5),phase1an(i,6));
[oean2(i,1:6)] = phase2oe(mu2(1),phase2an(i,1),phase2an(i,2),phase2an(i,3),phase2an(i,4),phase2an(i,5),phase2an(i,6));

dummy(i,:) = [ooe1(i,:), oean1(i,:)];

end