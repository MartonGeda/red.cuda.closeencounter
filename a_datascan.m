%%Close encounter data
clear all

runnum = 1;
pc_laptop = 'D';            %'D' : pc, 'C' : laptop

currentdir = strcat(pc_laptop,':\Work\ELTE\TDK\red.cuda\TestRun\CloseEncounter\2D\Run_',int2str(runnum),'\');
rawparams = importdata(strcat(currentdir,'D_cpu_ns_as_RKF8_event.txt'));

if ~strcmp(unique(rawparams.textdata),'CLOSE_ENCOUNTER')
    error('Not just close encounter events happened')
end

params = rawparams.data(:,1:34);
delete rawparams

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

j = 1;
for i=1:(length(params)-1)
   if id1(i) ~= id1(i+1) || id2(i) ~= id2(i+1) || t(i+1) - t(i) > 5
       j = j + 1;
   end
end

N = j;                      %number of close encounters
j = 1;

pos = zeros(N,1);           %position of the last step of close encounter
timeofce = zeros(N,1);      %time of close encounter event

for i=1:(length(params)-1)
   if id1(i) ~= id1(i+1) || id2(i) ~= id2(i+1) || t(i+1) - t(i) > 5
       pos(j) = i;
       j = j + 1;
   end
end
pos(j) = length(params);

for i=1:length(timeofce)
   if i==1
       timeofce(i) = t(pos(i)) - t(i);
   else
       timeofce(i) = t(pos(i)) - t(pos(i-1)+1);
   end
end



