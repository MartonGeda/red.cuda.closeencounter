%% Orbital Elements, time

% if save == true, then save figures
save = false;

for i=1:2
   if i == 1
      ii = 1:pos(1);
      %figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
   else
      ii = pos(i-1)+1:pos(i);    
   end  
    figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

    subplot(2,2,1);
    plot(t(ii) - t(ii(1)),oe1(ii,1),'*',t(ii) - t(ii(1)),oe2(ii,1),'*');
    title('semimajor axis');
    xlabel('time (day)');
    ylabel('a (AU)');
    lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
    p = get(lh,'Position');
    p(1) = 0.93;
    p(2) = 0.95;
    set(lh,'Position',p);

    subplot(2,2,2);
    plot(t(ii) - t(ii(1)),oe1(ii,2),'*',t(ii) - t(ii(1)),oe2(ii,2),'*');
    title('eccentricity');
    xlabel('time (day)');
    ylabel('e (-)');

    subplot(2,2,3);
    plot(t(ii) - t(ii(1)),oe1(ii,4),'*',t(ii) - t(ii(1)),oe2(ii,4),'*');
    title('argument of pericenter');
    xlabel('time (day)');
    ylabel('w (rad)');

    subplot(2,2,4);
    plot(t(ii) - t(ii(1)),oe1(ii,6),'*',t(ii) - t(ii(1)),oe2(ii,6),'*');
    title('mean anomaly');
    xlabel('time (day)');
    ylabel('M (rad)');  

    suptitle(sprintf('time, t = %5.2f day',t(ii(1))));

    if(save)
        if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
            mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
        end
        cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
        set(gcf,'PaperPositionMode','auto');
        print('-dpng',strcat('OrbEl',int2str(i)));  
    end
end

%%

% if save == true, then save figures
save = false;

for i=1:N
        figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

        subplot(2,2,1);
        plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),oe1(ii,1),'*',t(ii) - t(ii(1)),oe2(ii,1),'*');
        title('semimajor axis');
        xlabel('time (day)');
        ylabel('a (AU)');
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        
        subplot(2,2,2);
        plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),oe1(ii,2),'*',t(ii) - t(ii(1)),oe2(ii,2),'*');
        title('eccentricity');
        xlabel('time (day)');
        ylabel('e (-)');
        
        subplot(2,2,3);
        plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),oe1(ii,4),'*',t(ii) - t(ii(1)),oe2(ii,4),'*');
        title('argument of pericenter');
        xlabel('time (day)');
        ylabel('w (rad)');
        
        subplot(2,2,4);
        plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),oe1(ii,6),'*',t(ii) - t(ii(1)),oe2(ii,6),'*');
        title('mean anomaly');
        xlabel('time (day)');
        ylabel('M (rad)');  
        
        suptitle(sprintf('time, t = %5.2f day',tres(idx(i,1))));
        
        if(save)
            if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
                mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            end
            cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('OrbEl',int2str(i)));  
        end
end
