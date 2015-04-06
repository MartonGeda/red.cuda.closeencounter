%% velocities, collision factor

% if save == true, then save figures
save = false;

for i=1
    if (i == 1)
        figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        subplot(1,2,1);
        plot(phase1(1:pos(1),4),phase1(1:pos(1),5),'*',phase2(1:pos(1),4),phase2(1:pos(1),5),'*');
        title('velocities of the bodies');
        xlabel('v_x (AU/day)');
        ylabel('v_y (AU/day)');  
        %axis equal
        lh = legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
        p = get(lh,'Position');
        p(1) = 0.48;
        p(2) = 0.89;
        set(lh,'Position',p);
        text(phase1(1,4),phase1(1,5),'   \leftarrow');
        text(phase2(1,4),phase2(1,5),'\rightarrow   ','HorizontalAlignment','right');
        
        subplot(1,2,2);
        plot(t(1:pos(1)) - t(1),cf(1:pos(1)),'*');
        title(sprintf('relative distances from time, t = %5.2f day',t(1)));
        xlabel('time (day)');
        ylabel('radii enhance factor');
        
        if(save)
            if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))),'dir'))
                mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
            end
            cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('VelCf',int2str(1)));
        end
      
    else 
        %figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        subplot(1,2,1);
        plot(phase1((pos(i-1)+1):pos(i),4),phase1((pos(i-1)+1):pos(i),5),'*',phase2((pos(i-1)+1):pos(i),4),phase2((pos(i-1)+1):pos(i),5),'*');
        title('velocities of the bodies');
        xlabel('v_x (AU/day)');
        ylabel('v_y (AU/day)');
        %axis equal
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.48;
        p(2) = 0.89;
        set(lh,'Position',p);
        text(phase1(pos(i-1)+1,4),phase1(pos(i-1)+1,5),'   \leftarrow');
        text(phase2(pos(i-1)+1,4),phase2(pos(i-1)+1,5),'\rightarrow   ','HorizontalAlignment','right');
        
        subplot(1,2,2);
        plot(t(pos(i-1)+1:pos(i)) - t(pos(i-1)+1),cf(pos(i-1)+1:pos(i)),'*');
        title(sprintf('relative distances from time, t = %5.2f day',t(pos(i-1)+1)));
        xlabel('time (day)');
        ylabel('radii enhance factor');
        
        if(save)
            if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
                mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            end
            cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('VelCf',int2str(i))); 
        end
    end
end