%% plot initial conditions from redcuda initial input.txt file

runnum = 1;                 %number of run folder
pc_laptop = 'D';            %'D' : pc, 'C' : laptop

currentdir = strcat(pc_laptop,':\Work\ELTE\TDK\red.cuda\TestRun\CloseEncounter\2D\Run_',int2str(runnum),'\');

C = importdata(strcat(currentdir,'input.txt'),' ',1);
phases = C.data(2:end,9:14);
figure();
plot(phases(:,1),phases(:,2),'*')
legend(int2str(length(phases)))