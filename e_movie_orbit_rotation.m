%% movie of the orbit rotation

% index of close encounter event

d_calculate_trueanomaly;
u = linspace(-pi,pi,1000);
for i=133

if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
    mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
end
cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));

writerObj = VideoWriter(strcat('OrbRot',int2str(i),'.mp4'),'MPEG-4');
writerObj.FrameRate = 10;
open(writerObj);

if (i == 1)  
    fig = figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

    mx1 = zeros(pos(1),length(u));
    my1 = zeros(pos(1),length(u));
    mx2 = zeros(pos(1),length(u));
    my2 = zeros(pos(1),length(u));
    
    for j = 1 : pos(1)
        a1 = oe1(j,1);
        e1 = oe1(j,2);
        w1 = oe1(j,4);
        r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
        mx1(j,:) = r1.*cos(u);
        my1(j,:) = r1.*sin(u);

        a2 = oe2(j,1);
        e2 = oe2(j,2);
        w2 = oe2(j,4);
        r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
        mx2(j,:) = r2.*cos(u);
        my2(j,:) = r2.*sin(u);
    end    
    
    for j=1:pos(1)
        a1 = oe1(j,1);
        e1 = oe1(j,2);
        w1 = oe1(j,4);
        r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
        x1 = r1.*cos(u);
        y1 = r1.*sin(u);

        a2 = oe2(j,1);
        e2 = oe2(j,2);
        w2 = oe2(j,4);
        r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
        x2 = r2.*cos(u);
        y2 = r2.*sin(u);
   
        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title(sprintf('orbit positons at time, t = %5.3f day, \\Deltat = %1.3f, cf = %1.3f',t(j),t(j) - t(1), cf(j)));
        xlabel('x (AU)');
        ylabel('y (AU)');
        lh = legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
        set(lh,'Box','off');
        axis([min([mx1(:); mx2(:)]) max([mx1(:); mx2(:)]) min([my1(:); my2(:)]) max([my1(:); my2(:)])]);

        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(j)))/1.2*cos(v2(j)+w2) a2*(1-e2^2)/(1+e2*cos(v2(j)))/1.2*sin(v2(j)+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(j)))*cos(v2(j)+w2) a2*(1-e2^2)/(1+e2*cos(v2(j)))*sin(v2(j)+w2)];

        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.5);
        
        fig.NextPlot = 'replaceChildren';
        drawnow
        F = getframe(fig);
        writeVideo(writerObj,F);    
    end
else
    fig = figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

    mx1 = zeros(pos(i) - pos(i-1),length(u));
    my1 = zeros(pos(i) - pos(i-1),length(u));
    mx2 = zeros(pos(i) - pos(i-1),length(u));
    my2 = zeros(pos(i) - pos(i-1),length(u));
    
    for j = 1 : (pos(i) - pos(i-1))
        a1 = oe1(pos(i-1)+j,1);
        e1 = oe1(pos(i-1)+j,2);
        w1 = oe1(pos(i-1)+j,4);
        r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
        mx1(j,:) = r1.*cos(u);
        my1(j,:) = r1.*sin(u);

        a2 = oe2(pos(i-1)+j,1);
        e2 = oe2(pos(i-1)+j,2);
        w2 = oe2(pos(i-1)+j,4);
        r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
        mx2(j,:) = r2.*cos(u);
        my2(j,:) = r2.*sin(u);
    end
    
    for j = 1 : (pos(i) - pos(i-1))
        a1 = oe1(pos(i-1)+j,1);
        e1 = oe1(pos(i-1)+j,2);
        w1 = oe1(pos(i-1)+j,4);
        r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
        x1 = r1.*cos(u);
        y1 = r1.*sin(u);

        a2 = oe2(pos(i-1)+j,1);
        e2 = oe2(pos(i-1)+j,2);
        w2 = oe2(pos(i-1)+j,4);
        r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
        x2 = r2.*cos(u);
        y2 = r2.*sin(u);

        plot(x1,y1,'.',x2,y2,'.')
        axis equal
        title(sprintf('orbit positons at time, t = %5.3f day, \\Deltat = %1.3f, cf = %1.3f',t(pos(i-1)+j),t(pos(i-1)+j) - t(pos(i-1)+1) , cf(pos(i-1)+j)));
        xlabel('x (AU)');
        ylabel('y (AU)');
        lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        set(lh,'Box','off');
        axis([min([mx1(:); mx2(:)]) max([mx1(:); mx2(:)]) min([my1(:); my2(:)]) max([my1(:); my2(:)])]);

        % lines from star to pericenter of body1, body2
        line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
        line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

        p1 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+j)))/1.2*cos(v2(pos(i-1)+j)+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+j)))/1.2*sin(v2(pos(i-1)+j)+w2)];
        p2 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+j)))*cos(v2(pos(i-1)+j)+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i-1)+j)))*sin(v2(pos(i-1)+j)+w2)];

        % arrow to the actual points of the bodies
        draw_arrow(p1,p2,0.5);
              
        fig.NextPlot = 'replaceChildren';
        drawnow
        F = getframe(fig);
        writeVideo(writerObj,F);
    end
end

close(writerObj);

end