%%Close encounter data
%clear all

runnum = 5;
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
for i=1:(size(params,1)-1)
   if id1(i) ~= id1(i+1) || id2(i) ~= id2(i+1) || t(i+1) - t(i) > 1
       j = j + 1;
   end
end

N = j;                      %number of close encounters
j = 1;

pos = zeros(N,1);           %position of the last step of close encounter
timeofce = zeros(N,1);      %time of close encounter event

for i=1:(size(params,1)-1)
   if id1(i) ~= id1(i+1) || id2(i) ~= id2(i+1) || t(i+1) - t(i) > 1
       pos(j) = i;
       j = j + 1;
   end
end
pos(j) = size(params,1);

dpos = zeros(N,1);
for i=1:size(dpos,1)
    if i==1
       dpos(1) = pos(1);
    else
       dpos(i) = pos(i) - (pos(i-1)+1) + 1; 
    end   
end

for i=1:size(pos,1)
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
dv = sqrt((phase1(:,4) - phase2(:,4)).^2 + (phase1(:,5) - phase2(:,5)).^2 + (phase1(:,6) - phase2(:,6)).^2);
rtkp = sqrt((phase1(:,1)/2 + phase2(:,1)/2).^2 + (phase1(:,2)/2 + phase2(:,2)/2).^2 + (phase1(:,3)/2 + phase2(:,3)/2).^2);


mu1 = 0.01720209895^2*(1+m1);
mu2 = 0.01720209895^2*(1+m2);

h1 = 0.5*absv1.^2 - mu1./absr1;
h2 = 0.5*absv2.^2 - mu2./absr2;

dh = zeros(size(params,1),1);
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

fx = 0.01720209895^2 * m1.* m2 ./ d.^3 .* (phase2(:,1) - phase1(:,1));
fy = 0.01720209895^2 * m1.* m2 ./ d.^3 .* (phase2(:,2) - phase1(:,2));
fz = 0.01720209895^2 * m1.* m2 ./ d.^3 .* (phase2(:,3) - phase1(:,3));
fij = 0.01720209895^2 * m1.* m2 ./ d.^2;

fsunx = [0.01720209895^2 * 1.* m1 ./ (phase1(:,1).^3 + phase1(:,2).^3 + phase1(:,3).^3) .* phase1(:,1), 0.01720209895^2 * 1.* m2 ./ (phase2(:,1).^3 + phase2(:,2).^3 + phase2(:,3).^3) .* phase2(:,1)];
fsuny = [0.01720209895^2 * 1.* m1 ./ (phase1(:,1).^3 + phase1(:,2).^3 + phase1(:,3).^3) .* phase1(:,2), 0.01720209895^2 * 1.* m2 ./ (phase2(:,1).^3 + phase2(:,2).^3 + phase2(:,3).^3) .* phase2(:,2)];
fsunz = [0.01720209895^2 * 1.* m1 ./ (phase1(:,1).^3 + phase1(:,2).^3 + phase1(:,3).^3) .* phase1(:,3), 0.01720209895^2 * 1.* m2 ./ (phase2(:,1).^3 + phase2(:,2).^3 + phase2(:,3).^3) .* phase2(:,3)];
fsun = [0.01720209895^2 * 1.* m1 ./ (phase1(:,1).^2 + phase1(:,2).^2 + phase1(:,3).^2), 0.01720209895^2 * 1.* m2 ./ (phase2(:,1).^2 + phase2(:,2).^2 + phase2(:,3).^2)];

%% binary result
tic;
runnum = 5;
pc_laptop = 'D';            %'D' : pc, 'C' : laptop

nob = 1001;         %number of bodies

currentdir = strcat(pc_laptop,':\Work\ELTE\TDK\red.cuda\TestRun\CloseEncounter\2D\Run_',int2str(runnum),'\');
fid = fopen(strcat(currentdir,'D_cpu_ns_as_RKF8_result.bin'));
fileInfo = dir(strcat(currentdir,'D_cpu_ns_as_RKF8_result.bin'));
fileSize = fileInfo.bytes;

id = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob); %average size of names is set to 5+1 byte
tres = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),1);
xres = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);
yres = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);
zres = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);
vxres = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);
vyres = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);
vzres = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);
name = cell(nob,1);
mass = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);
radius = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);
density = zeros(ceil(fileSize / (8 + (4+6+4+4*8+4+8+6*8)*nob)),nob);

i = 1;

while fileSize ~= ftell(fid)
    tres(i) = fread(fid,1,'double');
    for j = 1:nob
        tmp = 1;
        n = char.empty(0,1);
        id(i,j) = fread(fid,1,'int');
        while tmp
            tmp = fread(fid,1,'*char')';
            n = strcat(n,tmp);
        end
        name{j} = n;
        type = fread(fid,1,'int');     % type
        mass(i,j) = fread(fid,1,'double');
        radius(i,j) = fread(fid,1,'double');
        density(i,j) = fread(fid,1,'double');
        fread(fid,1,'double');      % cd
        
        fread(fid,1,'int');      % migration type
        fread(fid,1,'double');      % migration stop at
        
        xres(i,j) = fread(fid,1,'double');
        yres(i,j) = fread(fid,1,'double');
        zres(i,j) = fread(fid,1,'double');
        vxres(i,j) = fread(fid,1,'double');
        vyres(i,j) = fread(fid,1,'double');
        vzres(i,j) = fread(fid,1,'double');
    end
    i = i+1;
end

fclose(fid);

tmp = find(id(:,1) == 0,1,'first') - 1;

id = id(1:tmp,:);
tres = tres(1:tmp,:);
xres = xres(1:tmp,:);
yres = yres(1:tmp,:);
zres = zres(1:tmp,:);
vxres = vxres(1:tmp,:);
vyres = vyres(1:tmp,:);
vzres = vzres(1:tmp,:);
mass = mass(1:tmp,:);
radius = radius(1:tmp,:);
density = density(1:tmp,:);

absrres = sqrt(xres.^2 + yres.^2 + zres.^2);
absvres = sqrt(vxres.^2 + vyres.^2 + vzres.^2);
hres = 0.5*absvres.^2 - 0.01720209895^2*(1+mass)./absrres; 

toc;
%% ascii result
tic;
runnum = 4;
pc_laptop = 'D';            %'D' : pc, 'C' : laptop

currentdir = strcat(pc_laptop,':\Work\ELTE\TDK\red.cuda\TestRun\CloseEncounter\2D\Run_',int2str(runnum),'\');
rawparams = importdata(strcat(currentdir,'D_cpu_ns_as_RKF8_result.txt'));

id = zeros(size(rawparams.textdata,1),1);
for i=1:size(rawparams.textdata,1)
    id(i) = str2double(rawparams.textdata{i,1});
end

% number of bodies
nob = max(unique(id));

paramsres = [id rawparams.data];
clear id
clear rawparams

tres = paramsres(1:nob:end,3);            %time in days

xres = zeros(length(tres),nob);           %x coord
yres = zeros(length(tres),nob);           %y coord
zres = zeros(length(tres),nob);           %z coord
vxres = zeros(length(tres),nob);          %x velocity
vyres = zeros(length(tres),nob);          %y velocity
vzres = zeros(length(tres),nob);          %z velocity

for i=1:size(tres,1)
    if i == 1
        xres(1,1:nob) = paramsres(1:nob,10);
        yres(1,1:nob) = paramsres(1:nob,11);
        zres(1,1:nob) = paramsres(1:nob,12);
        vxres(1,1:nob) = paramsres(1:nob,13);
        vyres(1,1:nob) = paramsres(1:nob,14);
        vzres(1,1:nob) = paramsres(1:nob,15);
    else
       xres(i,1:nob) = paramsres((i-1)*nob+1 : i*nob,10);
       yres(i,1:nob) = paramsres((i-1)*nob+1 : i*nob,11);
       zres(i,1:nob) = paramsres((i-1)*nob+1 : i*nob,12);
       vxres(i,1:nob) = paramsres((i-1)*nob+1 : i*nob,13);
       vyres(i,1:nob) = paramsres((i-1)*nob+1 : i*nob,14);
       vzres(i,1:nob) = paramsres((i-1)*nob+1 : i*nob,15);
    end
end

% TODO: scan masses,densities, radiis

absrres = sqrt(xres.^2 + yres.^2 + zres.^2);
absvres = sqrt(vxres.^2 + vyres.^2 + vzres.^2);
hres = 0.5*absvres.^2 - 0.01720209895^2*(1+m1(1))./absrres;     % if masses are not equal it doesn't work!!
toc;


%% distances

% matching t, tres
indx1 = zeros(size(tres,1),1);
%m = zeros(size(tres,1),1);
for i=1:size(tres,1)
   [~, indx1(i)] = min(abs(t - tres(i)));   
end

% matching tres, t
indx2 = zeros(size(t,1),1);
%m = zeros(size(tres,1),1);
for i=1:size(t,1)
   [~, indx2(i)] = min(abs(t(i) - tres));   
end

% calculate distances from mass center of the bodies
dres = zeros(size(xres));

for i=1:size(dres,1)
    tmp = [(xres(i,id1(indx1(i))) + xres(i,id2(indx1(i)))) / 2, (yres(i,id1(indx1(i))) + yres(i,id2(indx1(i)))) / 2, (zres(i,id1(indx1(i))) + zres(i,id2(indx1(i)))) / 2 ];
    %tmp = [x(i,id1(idx(i))), y(i,id1(idx(i))), z(i,id1(idx(i)))];
    dres(i,:) = sqrt( (xres(i,:) - tmp(1)).^2 + (yres(i,:) - tmp(2)).^2 + (zres(i,:) - tmp(3)).^2 );
end
[dres, ind]= sort(dres,2);

% ONLY IF THE MASSES ARE EQUAL
forces = 0.01720209895^2 * m1(1) * m2(1) ./ dres.^2;

idx = zeros(size(pos,1),2);

for i=1:size(pos,1)
    if i == 1
        [~, idx(1,1)] = min(abs(t(1) - tres));
        [~, idx(1,2)] = min(abs(t(pos(1)) - tres));
    else
        [~, idx(i,1)] = min(abs(t(pos(i-1)+1) - tres));
        [~, idx(i,2)] = min(abs(t(pos(i)) - tres));
    end
end
