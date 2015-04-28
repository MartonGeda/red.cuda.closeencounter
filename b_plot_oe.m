%% Orbital Elements, time

% if save == true, then save figures
save = false;

for i=60
    if (i == 1)
        figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

        subplot(2,2,1);
        plot(t(1:pos(1)) - t(1),oe1(1:pos(1),1),'*',t(1:pos(1)) - t(1),oe2(1:pos(1),1),'*');
        title('semimajor axis');
        xlabel('time (day)');
        ylabel('a (AU)');
        lh = legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        
        subplot(2,2,2);
        plot(t(1:pos(1)) - t(1),oe1(1:pos(1),2),'*',t(1:pos(1)) - t(1),oe2(1:pos(1),2),'*');
        title('eccentricity');
        xlabel('time (day)');
        ylabel('e (-)');
        
        subplot(2,2,3);
        plot(t(1:pos(1)) - t(1),oe1(1:pos(1),4),'*',t(1:pos(1)) - t(1),oe2(1:pos(1),4),'*');
        title('argument of pericenter');
        xlabel('time (day)');
        ylabel('w (rad)');
         
        subplot(2,2,4);
        plot(t(1:pos(1)) - t(1),oe1(1:pos(1),6),'*',t(1:pos(1)) - t(1),oe2(1:pos(1),6),'*');
        title('mean anomaly');
        xlabel('time (day)');
        ylabel('M (rad)');
        
        suptitle(sprintf('time, t = %5.2f day',t(1)));
        
        if(save)
            if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))),'dir'))
                mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
            end
            cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('OrbEl',int2str(1))); 
        end
    else 
        %figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

        subplot(2,2,1);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe1((pos(i-1)+1):pos(i),1),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),1),'*');
        title('semimajor axis');
        xlabel('time (day)');
        ylabel('a (AU)');
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        
        subplot(2,2,2);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe1((pos(i-1)+1):pos(i),2),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),2),'*');
        title('eccentricity');
        xlabel('time (day)');
        ylabel('e (-)');
        
        subplot(2,2,3);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe1((pos(i-1)+1):pos(i),4),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),4),'*');
        title('argument of pericenter');
        xlabel('time (day)');
        ylabel('w (rad)');
        
        subplot(2,2,4);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe1((pos(i-1)+1):pos(i),6),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),6),'*');
        title('mean anomaly');
        xlabel('time (day)');
        ylabel('M (rad)');  
        
        suptitle(sprintf('time, t = %5.2f day',t(pos(i-1)+1)));
        
        if(save)
            if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
                mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            end
            cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('OrbEl',int2str(i)));  
        end
    end
end

%%

% if save == true, then save figures
save = false;

for i=1:N
        figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

        subplot(2,2,1);
        plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),oe1((pos(i-1)+1):pos(i),1),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),1),'*');
        title('semimajor axis');
        xlabel('time (day)');
        ylabel('a (AU)');
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        
        subplot(2,2,2);
        plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),oe1((pos(i-1)+1):pos(i),2),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),2),'*');
        title('eccentricity');
        xlabel('time (day)');
        ylabel('e (-)');
        
        subplot(2,2,3);
        plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),oe1((pos(i-1)+1):pos(i),4),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),4),'*');
        title('argument of pericenter');
        xlabel('time (day)');
        ylabel('w (rad)');
        
        subplot(2,2,4);
        plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),oe1((pos(i-1)+1):pos(i),6),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),6),'*');
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
