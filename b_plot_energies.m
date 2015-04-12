%% plot energies

% if save == true, then save figures
save = false;

d_calculate_trueanomaly;
d_calculate_angleofintersection;

for i = 1:N
    if i==1
        figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        
        subplot(3,2,1);
        plot(t(1:pos(1)) - t(1),absr1(1:pos(1)) - absr1(1) ,'*', t(1:pos(1)) - t(1),absr2(1:pos(1)) - absr2(1) ,'*');
        title('relative changing in distances from star');
        xlabel('time (day)');
        ylabel('dr (AU)');        
        lh = legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
        p = get(lh,'Position');
        p(1) = 0.9335;
        p(2) = 0.940;
        set(lh,'Position',p);         
        
        subplot(3,2,2); 
        plot(t(1:pos(1)) - t(1),(absr1(1:pos(1)) - absr1(1) + absr2(1:pos(1)) - absr2(1)) / 2,'*','Color','m');
        title('relative changing in average distances from star');
        xlabel('time (day)');
        ylabel('dr (AU)');
        
        subplot(3,2,3); 
        plot(t(1:pos(1)) - t(1),absv1(1:pos(1)) - absv1(1) ,'*', t(1:pos(1)) - t(1),absv2(1:pos(1)) - absv2(1) ,'*');
        title('relative changing in velocities from star');
        xlabel('time (day)');
        ylabel('dv (AU/day)');   
        
        subplot(3,2,4); 
        plot(t(1:pos(1)) - t(1),(absv1(1:pos(1)) - absv1(1) + absv2(1:pos(1)) - absv2(1)) / 2 ,'*','Color','m'); 
        title('relative changing in average velocities from star');
        xlabel('time (day)');
        ylabel('dv (AU/day)');   
        
        subplot(3,3,7);
        plot(t(1:pos(1)) - t(1),0.5*(absv1(1:pos(1)).^2 - absv1(1).^2 + absv2(1:pos(1)).^2 - absv2(1).^2) / 2 ,'*','Color','m');
        title('relative changing in kinetic energy');
        xlabel('time (day)');
        ylabel('dh_{k} (AU^2/day^2)');
        
        subplot(3,3,8);
        plot(t(1:pos(1)) - t(1), -(mu1(1:pos(1))./absr1(1:pos(1)) - mu1(1)./absr1(1) + mu2(1:pos(1))./absr2(1:pos(1)) - mu2(1)./absr2(1)) / 2 ,'*','Color','m');
        title('relative changing in potential energy');
        xlabel('time (day)');
        ylabel('dh_{p} (AU^2/day^2)');
        
        subplot(3,3,9);
        plot(t(1:pos(1)) - t(1),dh(1:pos(1)) - dh(1),'*','Color','m');
        title('relative changing in total energy');
        xlabel('time (day)');
        ylabel('dh (AU^2/day^2)');
        
        suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day, angle of intersection \\Phi = %2.2f°, cf_{min} = %1.4f',t(1),timeofce(1),alpha(1),Cf(1)));
        
        if(save)
%             if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))),'dir'))
%                 mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
%             end
%             cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('En',int2str(1)));  
        end        
   else
        figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        
        subplot(3,2,1);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),absr1((pos(i-1)+1):pos(i)) - absr1(pos(i-1)+1) ,'*', t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),absr2((pos(i-1)+1):pos(i)) - absr2(pos(i-1)+1) ,'*');
        title('relative changing in distances from star');
        xlabel('time (day)');
        ylabel('dr (AU)');          
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.9335;
        p(2) = 0.940;
        set(lh,'Position',p);        
        
        subplot(3,2,2); 
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),(absr1((pos(i-1)+1):pos(i)) - absr1(pos(i-1)+1) + absr2((pos(i-1)+1):pos(i)) - absr2(pos(i-1)+1)) / 2,'*','Color','m');
        title('relative changing in average distances from star');
        xlabel('time (day)');
        ylabel('dr (AU)');        
        
        subplot(3,2,3); 
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),absv1((pos(i-1)+1):pos(i)) - absv1(pos(i-1)+1) ,'*', t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),absv2((pos(i-1)+1):pos(i)) - absv2(pos(i-1)+1) ,'*');
        title('relative changing in velocities from star');
        xlabel('time (day)');
        ylabel('dv (AU/day)');         
        
        subplot(3,2,4); 
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),(absv1((pos(i-1)+1):pos(i)) - absv1(pos(i-1)+1) + absv2((pos(i-1)+1):pos(i)) - absv2(pos(i-1)+1)) / 2 ,'*','Color','m'); 
        title('relative changing in average velocities from star');
        xlabel('time (day)');
        ylabel('dv (AU/day)');         
        
        subplot(3,3,7);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),0.5*(absv1((pos(i-1)+1):pos(i)).^2 - absv1(pos(i-1)+1).^2 + absv2((pos(i-1)+1):pos(i)).^2 - absv2(pos(i-1)+1).^2) / 2 ,'*','Color','m');
        title('relative changing in kinetic energy');
        xlabel('time (day)');
        ylabel('dh_{k} (AU^2/day^2)');
        
        subplot(3,3,8);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),-(mu1((pos(i-1)+1):pos(i))./absr1((pos(i-1)+1):pos(i)) - mu1(pos(i-1)+1)./absr1(pos(i-1)+1) + mu2((pos(i-1)+1):pos(i))./absr2((pos(i-1)+1):pos(i)) - mu2(pos(i-1)+1)./absr2(pos(i-1)+1)) / 2 ,'*','Color','m');
        title('relative changing in potential energy');
        xlabel('time (day)');
        ylabel('dh_{p} (AU^2/day^2)');        
        
        subplot(3,3,9);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),dh((pos(i-1)+1):pos(i)) - dh(pos(i-1)+1),'*','Color','m');
        title('relative changing in total energy');
        xlabel('time (day)');
        ylabel('dh (AU^2/day^2)');        
         
        suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day, angle of intersection \\Phi = %2.2f°, cf_{min} = %1.4f',t(pos(i-1)+1),timeofce(i),alpha(i),Cf(i)));  

        if(save)
%             if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
%                 mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
%             end
%             cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('En',int2str(i)));  
        end           
   end
end

%%
from = 1;
to = 2;

for i=1:N
%     figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
%     subplot(2,2,1)
%     plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),hres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - hres(idx(i,1),ind(idx(i,1),3)),'*');
%     subplot(2,2,2)
%     plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),hres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - hres(idx(i,1),ind(idx(i,1),4)),'*');
%     subplot(2,2,3)
%     plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),hres(idx(i,1):idx(i,2),ind(idx(i,1),5)) - hres(idx(i,1),ind(idx(i,1),5)),'*');
%     subplot(2,2,4)
%     plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),hres(idx(i,1):idx(i,2),ind(idx(i,1),6)) - hres(idx(i,1),ind(idx(i,1),6)),'*');
%     
    figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
    %plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), mean(hres(idx(i,1):idx(i,2),ind(idx(i,1),3:4)),2) - mean(hres(idx(i,1),ind(idx(i,1),3:4)),2),'*');
    subplot(3,2,1)
    plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), absrres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - absrres(idx(i,1),ind(idx(i,1),3)),'*', tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), absrres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - absrres(idx(i,1),ind(idx(i,1),4)),'*');
    
    subplot(3,2,2)
    plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), (absrres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - absrres(idx(i,1),ind(idx(i,1),3)) + absrres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - absrres(idx(i,1),ind(idx(i,1),4))) / 2,'*','Color','m');
    
    subplot(3,2,3)
    plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), absvres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - absvres(idx(i,1),ind(idx(i,1),3)),'*', tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), absvres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - absvres(idx(i,1),ind(idx(i,1),4)),'*');
    
    subplot(3,2,4)
    plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), (absvres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - absvres(idx(i,1),ind(idx(i,1),3)) + absvres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - absvres(idx(i,1),ind(idx(i,1),4))) / 2,'*','Color','m');
    
    subplot(3,3,7)
    %plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), 0.5*(absvres(idx(i,1):idx(i,2),ind(idx(i,1),3)).^2 - absvres(idx(i,1),ind(idx(i,1),3)).^2),'*', tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), 0.5*(absvres(idx(i,1):idx(i,2),ind(idx(i,1),4)).^2 - absvres(idx(i,1),ind(idx(i,1),4)).^2),'*', tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), 0.5*(absvres(idx(i,1):idx(i,2),ind(idx(i,1),3)).^2 - absvres(idx(i,1),ind(idx(i,1),3)).^2 + absvres(idx(i,1):idx(i,2),ind(idx(i,1),4)).^2 - absvres(idx(i,1),ind(idx(i,1),4)).^2) / 2,'*');
    plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), mean(0.5*absvres(idx(i,1):idx(i,2),ind(idx(i,1),from:to)).^2,2) - mean(0.5*absvres(idx(i,1),ind(idx(i,1),from:to)).^2,2) ,'*','Color','m');

    subplot(3,3,8)
    %plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), -(mu1(1)./absrres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - mu1(1)./absrres(idx(i,1),ind(idx(i,1),3))),'*', tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), -(mu1(1)./absrres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - mu1(1)./absrres(idx(i,1),ind(idx(i,1),4))),'*', tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), (-(mu1(1)./absrres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - mu1(1)./absrres(idx(i,1),ind(idx(i,1),3))) -(mu1(1)./absrres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - mu1(1)./absrres(idx(i,1),ind(idx(i,1),4)))) / 2,'*');
    plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)), mean(-mu1(1)./absrres(idx(i,1):idx(i,2),ind(idx(i,1),from:to)),2) - mean(-mu1(1)./absrres(idx(i,1),ind(idx(i,1),from:to)),2) ,'*','Color','m');
        
    subplot(3,3,9)
    %plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),hres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - hres(idx(i,1),ind(idx(i,1),3)),'*', tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),hres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - hres(idx(i,1),ind(idx(i,1),4)),'*', tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),(hres(idx(i,1):idx(i,2),ind(idx(i,1),3)) - hres(idx(i,1),ind(idx(i,1),3)) + hres(idx(i,1):idx(i,2),ind(idx(i,1),4)) - hres(idx(i,1),ind(idx(i,1),4))) / 2,'*');
    plot(tres(idx(i,1):idx(i,2)) - tres(idx(i,1)),mean(hres(idx(i,1):idx(i,2),ind(idx(i,1),from:to)),2) - mean(hres(idx(i,1),ind(idx(i,1),from:to)),2),'*','Color','m');
    
    if i==1
    suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day, angle of intersection \\Phi = %2.2f°, cf_{min} = %1.4f',t(1),timeofce(1),alpha(1),Cf(1)));  
    else
    suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day, angle of intersection \\Phi = %2.2f°, cf_{min} = %1.4f',t(pos(i-1)+1),timeofce(i),alpha(i),Cf(i)));      
    end
    
end
