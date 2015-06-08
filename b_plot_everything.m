%% plot pos,vel,cf,oe,(v),ellipses before, ellipses after
tic;
% if save == true, then save figures
savepic = false;

d_calculate_trueanomaly;
%d_calculate_angleofintersection;
u = linspace(-pi,pi,1000);

for i=1:N
   if i == 1
      ii = 1:pos(1);
      %figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
   else
      ii = pos(i-1)+1:pos(i);    
   end 

    figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

    subplot(3,3,1);
    plot(phase1(ii,1),phase1(ii,2),'*',phase2(ii,1),phase2(ii,2),'*');
    title('positions of the bodies');
    xlabel('x (AU)');
    ylabel('y (AU)');
    axis equal
    lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
    p = get(lh,'Position');
    p(1) = 0.9335;
    p(2) = 0.940;
    set(lh,'Position',p);
    text(phase1(ii(1),1),phase1(ii(1),2),'   \leftarrow');
    text(phase2(ii(1),1),phase2(ii(1),2),'\rightarrow   ','HorizontalAlignment','right');        
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);        

    subplot(3,3,2);
    plot(1.495978707e8 / 86400 * phase1(ii,4),1.495978707e8 / 86400 * phase1(ii,5),'*',1.495978707e8 / 86400 * phase2(ii,4),1.495978707e8 / 86400 * phase2(ii,5),'*');   
    title('velocities of the bodies');
    xlabel('v_x (km/s)');
    ylabel('v_y (km/s)');         
    text(1.495978707e8 / 86400 * phase1(ii(1),4),1.495978707e8 / 86400 * phase1(ii(1),5),'   \leftarrow');
    text(1.495978707e8 / 86400 * phase2(ii(1),4),1.495978707e8 / 86400 * phase2(ii(1),5),'\rightarrow   ','HorizontalAlignment','right');
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);        

    subplot(3,3,3);
    [hAx,hLine1,hLine2] = plotyy(t(ii) - t(ii(1)),cf(ii),t(ii) - t(ii(1)),fij(ii)./fsun(ii,1));
    title('relative distances, forces');
    xlabel('time (day)');
    ylabel(hAx(1),'r_{ij}/(R_i + R_j)');
    ylabel(hAx(2),'F_{ij}/F_{Sun}');
    hLine1.LineStyle = 'none';
    hLine2.LineStyle = 'none';
    set(hLine1,'Marker','*','Color','m');
    set(hLine2,'Marker','*','Color','k');
    set(hAx,{'ycolor'},{'m';'k'});
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);     

    subplot(3,3,4);
    plot(t(ii) - t(ii(1)),oe1(ii,1),'*',t(ii) - t(ii(1)),oe2(ii,1),'*');
    %plot(t(ii) - t(ii(1)),oe1(ii,2).*cos(oe1(ii,4)),'*',t(ii) - t(ii(1)),oe2(ii,2).*cos(oe2(ii,4)),'*');
    %plot(t(ii) - t(ii(1)),abs(oe1(ii,1) - oe2(ii,1)),'*','Color','m');
    title('semimajor axis');
    xlabel('time (day)');
    ylabel('a (AU)');
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);        

    subplot(3,3,5);
    plot(t(ii) - t(ii(1)),oe1(ii,2),'*',t(ii) - t(ii(1)),oe2(ii,2),'*');
    %plot(t(ii) - t(ii(1)),oe1(ii,2).*sin(oe1(ii,4)),'*',t(ii) - t(ii(1)),oe2(ii,2).*sin(oe2(ii,4)),'*');
    %plot(t(ii) - t(ii(1)),abs(oe1(ii,2) - oe2(ii,2)),'*','Color','m');
    title('eccentricity');
    xlabel('time (day)');
    ylabel('e (-)');
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);        

    subplot(3,3,6);
    plot(t(ii) - t(ii(1)),oe1(ii,4),'*',t(ii) - t(ii(1)),oe2(ii,4),'*');
    %plot(t(ii) - t(ii(1)),oe1(ii,1).*cos(oe1(ii,6)),'*',t(ii) - t(ii(1)),oe2(ii,1).*cos(oe2(ii,6)),'*');
    %plot(t(ii) - t(ii(1)),abs(oe1(ii,4) - oe2(ii,4)),'*','Color','m');
    title('argument of pericenter');
    xlabel('time (day)');
    ylabel('w (rad)');
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);        

    subplot(3,3,7);
    plot(t(ii) - t(ii(1)),oe1(ii,6),'*',t(ii) - t(ii(1)),oe2(ii,6),'*');
    %plot(t(ii) - t(ii(1)),oe1(ii,1).*sin(oe1(ii,6)),'*',t(ii) - t(ii(1)),oe2(ii,1).*sin(oe2(ii,6)),'*');
    %plot(t(ii) - t(ii(1)),abs(oe1(ii,6) - oe2(ii,6)),'*','Color','m');
    title('mean anomaly');
    xlabel('time (day)');
    ylabel('M (rad)');  
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);

%         subplot(3,3,8);
%         plot(t(ii) - t(ii(1)),v1(ii),'*',t(ii) - t(ii(1)),v2(ii),'*');
%         title('true anomaly');
%         xlabel('time (day)');
%         ylabel('v (rad)');

%         subplot(3,3,8);
%         plot(1.495978707e8*(phase1(ii,1) - phase2(ii,1)),1.495978707e8*(phase1(ii,2) - phase2(ii,2)),'*',0,0,'*');
%         title('relative positions');
%         xlabel('x (AU)');
%         ylabel('y (AU)');
%         axis equal;

    a1 = oe1(ii(1),1);
    e1 = oe1(ii(1),2);
    w1 = oe1(ii(1),4);
    r1 = a1*(1-e1^2)./(1+e1*cos(u-w1));
    x1 = r1.*cos(u);
    y1 = r1.*sin(u);

    a2 = oe2(ii(1),1);
    e2 = oe2(ii(1),2);
    w2 = oe2(ii(1),4);
    r2 = a2*(1-e2^2)./(1+e2*cos(u-w2));
    x2 = r2.*cos(u);
    y2 = r2.*sin(u);

    subplot(3,3,8);
    plot(x1,y1,'.',x2,y2,'.')
    axis equal
    title('positions of the intersecting orbits (before)');
    xlabel('x (AU)');
    ylabel('y (AU)');
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);

    % lines from star to pericenter of body1, body2
    line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
    line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

    p1 = [a2*(1-e2^2)/(1+e2*cos(v2(ii(1))))/2*cos(v2(ii(1))+w2) a2*(1-e2^2)/(1+e2*cos(v2(ii(1))))/2*sin(v2(ii(1))+w2)];
    p2 = [a2*(1-e2^2)/(1+e2*cos(v2(ii(1))))*cos(v2(ii(1))+w2) a2*(1-e2^2)/(1+e2*cos(v2(ii(1))))*sin(v2(ii(1))+w2)];

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
    p = get(gca,'position');
    p(1) = p(1) - 0.03;
    set(gca,'position',p);

    % lines from star to pericenter of body1, body2
    line([0 a1*(1-e1)*cos(w1)],[0 a1*(1-e1)*sin(w1)]);   
    line([0 a2*(1-e2)*cos(w2)],[0 a2*(1-e2)*sin(w2)],'Color','r');

    p1 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))/2*cos(v2(pos(i))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))/2*sin(v2(pos(i))+w2)];
    p2 = [a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))*cos(v2(pos(i))+w2) a2*(1-e2^2)/(1+e2*cos(v2(pos(i))))*sin(v2(pos(i))+w2)];

    % arrow to the actual points of the bodies
    draw_arrow(p1,p2,0.8);

    data = num2cell([ind(idx(i,1),3:7)' , dres(idx(i,1),3:7)']);
    tab = uitable('Data',data,'ColumnName',{'id','distance (AU)'},'RowName',[],'ColumnWidth',{45,'auto'},'FontSize',10);
    tab.Position(1) = 1530;
    tab.Position(2) = 690;
    tab.Position(3:4) = tab.Extent(3:4);
    uicontrol('Style','text','Position',[1535 815 tab.Position(3) tab.Position(4)-95],'String','distance to five closest bodies','FontWeight','bold','BackgroundColor','w');

    jscrollpane = findjobj(tab);
    jTable = jscrollpane.getViewport.getView;
    cellStyle = jTable.getCellStyleAt(0,0);
    cellStyle.setHorizontalAlignment(cellStyle.CENTER);
    jTable.repaint;

    [fmin,imin] = min(fij(ii));
    [fmax,imax] = max(fij(ii));
    if i~=1
        imin = imin + pos(i-1);
        imax = imax + pos(i-1);
    end

    suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day, angle of intersection \\Phi = %2.2f°, cf_{min} = %1.4f  \n ratio of the min forces F_{ij} : F_s : F_k = %g : %1.1g : %1.1g \t ratio of the max forces F_{ij} : F_s : F_k = %g : %1.1g : %1.1g',t(ii(1)),timeofce(i),alpha(i),Cf(i),1,fsun(imin,1)/fmin,forces(indx2(imin),3)/fmin,1,fsun(imax,1)/fmax,forces(indx2(imax),3)/fmax ));  

    if(savepic)
%             if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
%                 mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
%             end
%             cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
        set(gcf,'PaperPositionMode','auto');
        print('-dpng',strcat('All',int2str(i)));  
    end
end
toc;

