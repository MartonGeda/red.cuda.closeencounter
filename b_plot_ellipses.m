%% plot the intersecting ellipses

% if save == true, then save figures
save = false;

d_calculate_trueanomaly;
u = linspace(-pi,pi,10000);

for i = 10
    if (i == 1)
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
        
        figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        subplot(1,2,1);
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title('positions of the intersecting orbits (before)');
        xlabel('x (AU)');
        ylabel('y (AU)');
        lh = legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        annotation('textbox',[0.151 0.854 0.294 0.026],'Color','b','String',sprintf('a = %1.3f, e = %1.3f, i = %1.1f, w = %1.3f, Om = %1.1f, M = %1.3f',oe1(1,1),oe1(1,2),oe1(1,3),oe1(1,4),oe1(1,5),oe1(1,6)),'LineStyle','none','FitBoxToText','off','HorizontalAlignment','center','Tag','oe');
        annotation('textbox',[0.151 0.834 0.294 0.026],'Color','r','String',sprintf('a = %1.3f, e = %1.3f, i = %1.1f, w = %1.3f, Om = %1.1f, M = %1.3f',oe2(1,1),oe2(1,2),oe2(1,3),oe2(1,4),oe2(1,5),oe2(1,6)),'LineStyle','none','FitBoxToText','off','HorizontalAlignment','center','Tag','oe');
        
        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(1)))/2*cos(v2(1)+w2) a2*(1-e2^2)/(1+e2*cos(v2(1)))/2*sin(v2(1)+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(1)))*cos(v2(1)+w2) a2*(1-e2^2)/(1+e2*cos(v2(1)))*sin(v2(1)+w2)];
   
        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.3);

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

        subplot(1,2,2);
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title('positions of the intersecting orbits (after)');
        xlabel('x (AU)');
        ylabel('y (AU)');
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        annotation('textbox',[0.593 0.854 0.294 0.026],'Color','b','String',sprintf('a = %1.3f, e = %1.3f, i = %1.1f, w = %1.3f, Om = %1.1f, M = %1.3f',oe1(pos(1),1),oe1(pos(1),2),oe1(pos(1),3),oe1(pos(1),4),oe1(pos(1),5),oe1(pos(1),6)),'LineStyle','none','FitBoxToText','off','HorizontalAlignment','center','Tag','oe');
        annotation('textbox',[0.593 0.834 0.294 0.026],'Color','r','String',sprintf('a = %1.3f, e = %1.3f, i = %1.1f, w = %1.3f, Om = %1.1f, M = %1.3f',oe2(pos(1),1),oe2(pos(1),2),oe2(pos(1),3),oe2(pos(1),4),oe2(pos(1),5),oe2(pos(1),6)),'LineStyle','none','FitBoxToText','off','HorizontalAlignment','center','Tag','oe');        

        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(1))))/2*cos(v2(pos(1))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(1))))/2*sin(v2(pos(1))+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(1))))*cos(v2(pos(1))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(1))))*sin(v2(pos(1))+w2)];
   
        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.3);
        
        suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day',t(1),timeofce(1)));  

        if(save)
            if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))),'dir'))
                mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
            end
            cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(1))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('Ell',int2str(1)));
        end
        
        delete(findall(gcf,'Tag','oe'))
        
    else
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

        subplot(1,2,1);
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title('positions of the intersecting orbits (before)');
        xlabel('x (AU)');
        ylabel('y (AU)');
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);
        annotation('textbox',[0.151 0.854 0.294 0.026],'Color','b','String',sprintf('a = %1.3f, e = %1.3f, i = %1.1f, w = %1.3f, Om = %1.1f, M = %1.3f',oe1(pos(i-1)+1,1),oe1(pos(i-1)+1,2),oe1(pos(i-1)+1,3),oe1(pos(i-1)+1,4),oe1(pos(i-1)+1,5),oe1(pos(i-1)+1,6)),'LineStyle','none','FitBoxToText','off','HorizontalAlignment','center','Tag','oe');
        annotation('textbox',[0.151 0.834 0.294 0.026],'Color','r','String',sprintf('a = %1.3f, e = %1.3f, i = %1.1f, w = %1.3f, Om = %1.1f, M = %1.3f',oe2(pos(i-1)+1,1),oe2(pos(i-1)+1,2),oe2(pos(i-1)+1,3),oe2(pos(i-1)+1,4),oe2(pos(i-1)+1,5),oe2(pos(i-1)+1,6)),'LineStyle','none','FitBoxToText','off','HorizontalAlignment','center','Tag','oe');
        
        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+1)))/2*cos(v2(pos(i-1)+1)+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+1)))/2*sin(v2(pos(i-1)+1)+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+1)))*cos(v2(pos(i-1)+1)+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+1)))*sin(v2(pos(i-1)+1)+w2)];

        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.4);            

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

        subplot(1,2,2);
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title('positions of the intersecting orbits (after)');
        xlabel('x (AU)');
        ylabel('y (AU)');
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        p = get(lh,'Position');
        p(1) = 0.93;
        p(2) = 0.95;
        set(lh,'Position',p);        
        annotation('textbox',[0.593 0.854 0.294 0.026],'Color','b','String',sprintf('a = %1.3f, e = %1.3f, i = %1.1f, w = %1.3f, Om = %1.1f, M = %1.3f',oe1(pos(i),1),oe1(pos(i),2),oe1(pos(i),3),oe1(pos(i),4),oe1(pos(i),5),oe1(pos(i),6)),'LineStyle','none','FitBoxToText','off','HorizontalAlignment','center','Tag','oe');
        annotation('textbox',[0.593 0.834 0.294 0.026],'Color','r','String',sprintf('a = %1.3f, e = %1.3f, i = %1.1f, w = %1.3f, Om = %1.1f, M = %1.3f',oe2(pos(i),1),oe2(pos(i),2),oe2(pos(i),3),oe2(pos(i),4),oe2(pos(i),5),oe2(pos(i),6)),'LineStyle','none','FitBoxToText','off','HorizontalAlignment','center','Tag','oe');
  
        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))/2*cos(v2(pos(i))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))/2*sin(v2(pos(i))+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))*cos(v2(pos(i))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))*sin(v2(pos(i))+w2)];

        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.4);
        
        suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day',t(pos(i-1)+1),timeofce(i)));  

        if(save)
            if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
                mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            end
            cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
            set(gcf,'PaperPositionMode','auto');
            print('-dpng',strcat('Ell',int2str(i)));   
        end
        
        delete(findall(gcf,'Tag','oe'))
        
    end
end