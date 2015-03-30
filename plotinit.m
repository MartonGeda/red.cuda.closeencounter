%% plot initial conditions from redcuda initial input.txt file

runnum = 2;                 %number of run folder
pc_laptop = 'D';            %'D' : pc, 'C' : laptop

currentdir = strcat(pc_laptop,':\Work\ELTE\TDK\red.cuda\TestRun\CloseEncounter\2D\Run_',int2str(runnum),'\');

C = importdata(strcat(currentdir,'input.txt'),' ',1);
phases = C.data(2:end,9:14);
figure('Name','Initial positions','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
plot(phases(:,1),phases(:,2),'*')
xlabel('x (AU)');
ylabel('y (AU)');
legend(int2str(length(phases)))