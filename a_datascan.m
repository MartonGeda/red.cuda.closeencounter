%%Close encounter data
clear all

runnum = 2;
pc_laptop = 'D';            %'D' : pc, 'C' : laptop

currentdir = strcat(pc_laptop,':\Work\ELTE\TDK\red.cuda\TestRun\CloseEncounter\2D\Run_',int2str(runnum),'\');
rawparams = importdata(strcat(currentdir,'D_cpu_ns_as_RKF8_event.txt'));

if ~strcmp(unique(rawparams.textdata),'CLOSE_ENCOUNTER')
    error('Not just close encounter events happened')
end

params = sortrows(rawparams.data(:,1:34),3);
%params = rawparams.data(:,1:34);
clear rawparams

t = params(:,1);            %time in days
id1 = params(:,3);          %id of body1
id2 = params(:,4);          %id of body2

j = 1;
for i=1:(length(params)-1)
   if id1(i) ~= id1(i+1) || id2(i) ~= id2(i+1) || t(i+1) - t(i) > 1
       j = j + 1;
   end
end

N = j;                      %number of close encounters
j = 1;

pos = zeros(N,1);           %position of the last step of close encounter
timeofce = zeros(N,1);      %time of close encounter event

for i=1:(length(params)-1)
   if id1(i) ~= id1(i+1) || id2(i) ~= id2(i+1) || t(i+1) - t(i) > 1
       pos(j) = i;
       j = j + 1;
   end
end
pos(j) = length(params);

for i=1:length(pos)
    if i==1
       params(1:pos(1),:) = sortrows(params(1:pos(1),:),1);
    else
       params(pos(i-1)+1:pos(i),:) = sortrows(params(pos(i-1)+1:pos(i),:),1); 
    end   
end

t = params(:,1);            %time in days
d = params(:,2);            %distance in au
id1 = params(:,3);          %id of body1
id2 = params(:,4);          %id of body2
m1 = params(:,5);           %mass of body1
rho1 = params(:,6);         %density of body1
r1 = params(:,7);           %radius of body1
phase1 = params(:,8:13);    %phase of body1
oe1 = params(:,14:19);      %orbital elements of body1
m2 = params(:,20);          %mass of body2
rho2 = params(:,21);        %density of body2
r2 = params(:,22);          %radius of body2
phase2 = params(:,23:28);   %phase of body2
oe2 = params(:,29:34);      %orbital elements of body2

cf = d ./ (r1 + r2);        %radii enhance factor

Cf = zeros(N,1);            %minimum distances between the bodies in radii units

for i = 1:N
   if (i == 1)
      Cf(1) = min(cf(1:pos(1)));
   else
      Cf(i) = min(cf((pos(i-1)+1):pos(i)));
   end
end

absr1 = sqrt(phase1(:,1).^2 + phase1(:,2).^2 + phase1(:,3).^2);
absr2 = sqrt(phase2(:,1).^2 + phase2(:,2).^2 + phase2(:,3).^2);
absv1 = sqrt(phase1(:,4).^2 + phase1(:,5).^2 + phase1(:,6).^2);
absv2 = sqrt(phase2(:,4).^2 + phase2(:,5).^2 + phase2(:,6).^2);

mu1 = 0.01720209895^2*(1+m1);
mu2 = 0.01720209895^2*(1+m2);

h1 = 0.5*absv1.^2 - mu1./absr1;
h2 = 0.5*absv2.^2 - mu2./absr2;

dh = zeros(length(params),1);
for i=1:N
    if (i==1)
       dh(1:pos(1)) = ((h1(1:pos(1)) + h2(1:pos(1))) / 2) - ((h1(1) + h2(1)) / 2);
    else
       dh(pos(i-1)+1:pos(i)) = ((h1(pos(i-1)+1:pos(i)) + h2(pos(i-1)+1:pos(i))) / 2) - ((h1(pos(i-1)+1) + h2(pos(i-1)+1)) / 2); 
    end
end


for i=1:N
   if i==1
       timeofce(i) = t(pos(i)) - t(i);
   else
       timeofce(i) = t(pos(i)) - t(pos(i-1)+1);
   end
end

%% ascii result

runnum = 3;
pc_laptop = 'D';            %'D' : pc, 'C' : laptop

currentdir = strcat(pc_laptop,':\Work\ELTE\TDK\red.cuda\TestRun\CloseEncounter\2D\Run_',int2str(runnum),'\');
rawparams = importdata(strcat(currentdir,'D_cpu_ns_as_RKF8_result.txt'));

id = zeros(length(rawparams.textdata),1);
for i=1:length(rawparams.textdata)
    id(i) = str2double(rawparams.textdata{i,1});
end

% number of bodies
Nres = max(unique(id));

paramsres = [id rawparams.data];
clear id
clear rawparams

tres = paramsres(1:Nres:end,3);            %time in days

x = zeros(length(tres),Nres);           %x coord
y = zeros(length(tres),Nres);           %y coord
z = zeros(length(tres),Nres);           %z coord
vx = zeros(length(tres),Nres);          %x velocity
vy = zeros(length(tres),Nres);          %y velocity
vz = zeros(length(tres),Nres);          %z velocity

for i=1:length(tres)
    if i == 1
        x(1,1:Nres) = paramsres(1:Nres,10);
        y(1,1:Nres) = paramsres(1:Nres,11);
        z(1,1:Nres) = paramsres(1:Nres,12);
        vx(1,1:Nres) = paramsres(1:Nres,13);
        vy(1,1:Nres) = paramsres(1:Nres,14);
        vz(1,1:Nres) = paramsres(1:Nres,15);
    else
       x(i,1:Nres) = paramsres((i-1)*Nres+1 : i*Nres,10);
       y(i,1:Nres) = paramsres((i-1)*Nres+1 : i*Nres,11);
       z(i,1:Nres) = paramsres((i-1)*Nres+1 : i*Nres,12);
       vx(i,1:Nres) = paramsres((i-1)*Nres+1 : i*Nres,13);
       vy(i,1:Nres) = paramsres((i-1)*Nres+1 : i*Nres,14);
       vz(i,1:Nres) = paramsres((i-1)*Nres+1 : i*Nres,15);
    end
end

hres = 0.5*(vx.^2 + vy.^2 + vz.^2) - 0.01720209895^2*(1+m1(1))./sqrt(x.^2 + y.^2 + z.^2);



%% distances

% matching t, tres
idx = zeros(length(tres),1);
m = zeros(length(tres),1);
for i=1:length(tres)
   [m(i), idx(i)] = min(abs(t - tres(i)));   
end

% calculate distances from mass center of the bodies
dres = zeros(size(x));

for i=1:length(dres)
    tmp = [(x(i,id1(idx(i))) + x(i,id2(idx(i)))) / 2, (y(i,id1(idx(i))) + y(i,id2(idx(i)))) / 2, (z(i,id1(idx(i))) + z(i,id2(idx(i)))) / 2 ];
    %tmp = [x(i,id1(idx(i))), y(i,id1(idx(i))), z(i,id1(idx(i)))];
    dres(i,:) = sqrt( (x(i,:) - tmp(1)).^2 + (y(i,:) - tmp(2)).^2 + (z(i,:) - tmp(3)).^2 );
end
[dres, ind]= sort(dres,2);

idx = zeros(length(pos),2);

for i=1:length(pos)
    if i == 1
        [~, idx(1,1)] = min(abs(t(1) - tres));
        [~, idx(1,2)] = min(abs(t(pos(1)) - tres));
    else
        [~, idx(i,1)] = min(abs(t(pos(i-1)+1) - tres));
        [~, idx(i,2)] = min(abs(t(pos(i)) - tres));
    end
end
