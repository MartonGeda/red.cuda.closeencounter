%% plot pos,vel,cf,oe,(v),ellipses before, ellipses after

d_calculate_trueanomaly;
u = linspace(-pi,pi,1000);

for i=1:N
    if (i==1)
        h = figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

        subplot(3,3,1)
        plot(phase1(1:pos(1),1),phase1(1:pos(1),2),'*',phase2(1:pos(1),1),phase2(1:pos(1),2),'*');
        title('positions of the bodies');
        xlabel('x (AU)');
        ylabel('y (AU)');
        lh = legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        text(phase1(1,1),phase1(1,2),'   \leftarrow');
        text(phase2(1,1),phase2(1,2),'\rightarrow   ','HorizontalAlignment','right');
        
        subplot(3,3,2);
        plot(phase1(1:pos(1),4),phase1(1:pos(1),5),'*',phase2(1:pos(1),4),phase2(1:pos(1),5),'*');
        title('velocities of the bodies');
        xlabel('v_x (AU/day)');
        ylabel('v_y (AU/day)');        
        text(phase1(1,4),phase1(1,5),'   \leftarrow');
        text(phase2(1,4),phase2(1,5),'\rightarrow   ','HorizontalAlignment','right');
        
        subplot(3,3,3);
        plot(t(1:pos(1)) - t(1),cf(1:pos(1)),'*');
        title('relative distances');
        xlabel('time (day)');
        ylabel('radii enhance factor');
        
        subplot(3,3,4);
        plot(t(1:pos(1)) - t(1),oe1(1:pos(1),1),'*',t(1:pos(1)) - t(1),oe2(1:pos(1),1),'*');
        title('semimajor axis');
        xlabel('time (day)');
        ylabel('a (AU)');
        
        subplot(3,3,5);
        plot(t(1:pos(1)) - t(1),oe1(1:pos(1),2),'*',t(1:pos(1)) - t(1),oe2(1:pos(1),2),'*');
        title('eccentricity');
        xlabel('time (day)');
        ylabel('e (-)');
        
        subplot(3,3,6);
        plot(t(1:pos(1)) - t(1),oe1(1:pos(1),4),'*',t(1:pos(1)) - t(1),oe2(1:pos(1),4),'*');
        title('argument of pericenter');
        xlabel('time (day)');
        ylabel('w (rad)');
         
        subplot(3,3,7);
        plot(t(1:pos(1)) - t(1),oe1(1:pos(1),6),'*',t(1:pos(1)) - t(1),oe2(1:pos(1),6),'*');
        title('mean anomaly');
        xlabel('time (day)');
        ylabel('M (rad)');
        
%         subplot(3,3,8);
%         plot(t(1:pos(1)) - t(1),v1(1:pos(1)),'*',t(1:pos(1)) - t(1),v2(1:pos(1)),'*');
%         title('true anomaly');
%         xlabel('time (day)');
%         ylabel('v (rad)');

        a1 = oe1(1,1);
        e1 = oe1(1,2);
        w1 = oe1(1,4);
        r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
        x1 = r1.*cos(u);
        y1 = r1.*sin(u);

        a2 = oe2(1,1);
        e2 = oe2(1,2);
        w2 = oe2(1,4);
        r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
        x2 = r2.*cos(u);
        y2 = r2.*sin(u);

        subplot(3,3,8);
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title('positions of the intersecting orbits (before)');
        xlabel('x (AU)');
        ylabel('y (AU)');

        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(1)))/2*cos(v2(1)+w2) a2*(1-e2^2)/(1+e2*cos(v2(1)))/2*sin(v2(1)+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(1)))*cos(v2(1)+w2) a2*(1-e2^2)/(1+e2*cos(v2(1)))*sin(v2(1)+w2)];
   
        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.8);

        a1 = oe1(pos(1),1);
        e1 = oe1(pos(1),2);
        w1 = oe1(pos(1),4);
        r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
        x1 = r1.*cos(u);
        y1 = r1.*sin(u);

        a2 = oe2(pos(1),1);
        e2 = oe2(pos(1),2);
        w2 = oe2(pos(1),4);
        r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
        x2 = r2.*cos(u);
        y2 = r2.*sin(u);

        subplot(3,3,9);
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title('positions of the intersecting orbits (after)');
        xlabel('x (AU)');
        ylabel('y (AU)');

        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(1))))/2*cos(v2(pos(1))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(1))))/2*sin(v2(pos(1))+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(1))))*cos(v2(pos(1))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(1))))*sin(v2(pos(1))+w2)];
   
        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.8);        
        
        suptitle(sprintf('time t = %5.2f day, time of event, \\Deltat = %1.3f day',t(1),timeofce(1)));

%         if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))),'dir'))
%             mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
%         end
%         cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1)))); 
        set(gcf,'PaperPositionMode','auto');
        print('-dpng',strcat('All',int2str(1)));  

    else
        %figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        
        subplot(3,3,1);
        plot(phase1(pos(i-1)+1:pos(i),1),phase1(pos(i-1)+1:pos(i),2),'*',phase2(pos(i-1)+1:pos(i),1),phase2(pos(i-1)+1:pos(i),2),'*');
        title('positions of the bodies');
        xlabel('x (AU)');
        ylabel('y (AU)');
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        text(phase1(pos(i-1)+1,1),phase1(pos(i-1)+1,2),'   \leftarrow');
        text(phase2(pos(i-1)+1,1),phase2(pos(i-1)+1,2),'\rightarrow   ','HorizontalAlignment','right');        
        
        subplot(3,3,2);
        plot(phase1((pos(i-1)+1):pos(i),4),phase1((pos(i-1)+1):pos(i),5),'*',phase2((pos(i-1)+1):pos(i),4),phase2((pos(i-1)+1):pos(i),5),'*');
        title('velocities of the bodies');
        xlabel('v_x (AU/day)');
        ylabel('v_y (AU/day)');         
        text(phase1(pos(i-1)+1,4),phase1(pos(i-1)+1,5),'   \leftarrow');
        text(phase2(pos(i-1)+1,4),phase2(pos(i-1)+1,5),'\rightarrow   ','HorizontalAlignment','right');
        
        subplot(3,3,3);
        plot(t(pos(i-1)+1:pos(i)) - t(pos(i-1)+1),cf(pos(i-1)+1:pos(i)),'*');
        title('relative distances');
        xlabel('time (day)');
        ylabel('radii enhance factor');
        
        subplot(3,3,4);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe1((pos(i-1)+1):pos(i),1),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),1),'*');
        title('semimajor axis');
        xlabel('time (day)');
        ylabel('a (AU)');
        
        subplot(3,3,5);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe1((pos(i-1)+1):pos(i),2),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),2),'*');
        title('eccentricity');
        xlabel('time (day)');
        ylabel('e (-)');
        
        subplot(3,3,6);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe1((pos(i-1)+1):pos(i),4),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),4),'*');
        title('argument of pericenter');
        xlabel('time (day)');
        ylabel('w (rad)');
        
        subplot(3,3,7);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe1((pos(i-1)+1):pos(i),6),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),oe2((pos(i-1)+1):pos(i),6),'*');
        title('mean anomaly');
        xlabel('time (day)');
        ylabel('M (rad)');  

%         subplot(3,3,8);
%         plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),v1((pos(i-1)+1):pos(i)),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),v2((pos(i-1)+1):pos(i)),'*');
%         title('true anomaly');
%         xlabel('time (day)');
%         ylabel('v (rad)');

        a1 = oe1(pos(i-1)+1,1);
        e1 = oe1(pos(i-1)+1,2);
        w1 = oe1(pos(i-1)+1,4);
        r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
        x1 = r1.*cos(u);
        y1 = r1.*sin(u);

        a2 = oe2(pos(i-1)+1,1);
        e2 = oe2(pos(i-1)+1,2);
        w2 = oe2(pos(i-1)+1,4);
        r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
        x2 = r2.*cos(u);
        y2 = r2.*sin(u);

        subplot(3,3,8);
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title('positions of the intersecting orbits (before)');
        xlabel('x (AU)');
        ylabel('y (AU)');

        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+1)))/2*cos(v2(pos(i-1)+1)+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+1)))/2*sin(v2(pos(i-1)+1)+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+1)))*cos(v2(pos(i-1)+1)+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+1)))*sin(v2(pos(i-1)+1)+w2)];

        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.8);            

        a1 = oe1(pos(i),1);
        e1 = oe1(pos(i),2);
        w1 = oe1(pos(i),4);
        r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
        x1 = r1.*cos(u);
        y1 = r1.*sin(u);

        a2 = oe2(pos(i),1);
        e2 = oe2(pos(i),2);
        w2 = oe2(pos(i),4);
        r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
        x2 = r2.*cos(u);
        y2 = r2.*sin(u);

        subplot(3,3,9);
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title('positions of the intersecting orbits (after)');
        xlabel('x (AU)');
        ylabel('y (AU)');

        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))/2*cos(v2(pos(i))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))/2*sin(v2(pos(i))+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))*cos(v2(pos(i))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))*sin(v2(pos(i))+w2)];

        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.8);       
        
        suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day',t(pos(i-1)+1),timeofce(i)));         

%         if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
%             mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
%         end
%         cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
        set(gcf,'PaperPositionMode','auto');
        print('-dpng',strcat('All',int2str(i)));    
    end    
end
