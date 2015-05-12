%% plot positions, radii enhance factor

% if save == true, then save figures
save = false;

for i = 1:3
   if i == 1
      ii = 1:pos(1);
      %  figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
   else
      ii = pos(i-1)+1:pos(i);    
   end
       
  figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
  subplot(1,2,1);
  plot(phase1(ii,1),phase1(ii,2),'*',phase2(ii,1),phase2(ii,2),'*');
  title('positions of the bodies');
  xlabel('x (AU)');
  ylabel('y (AU)');
  axis equal
  lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
  p = get(lh,'Position');
  p(1) = 0.48;
  p(2) = 0.89;
  set(lh,'Position',p);
  text(phase1(ii(1),1),phase1(ii(1),2),'   \leftarrow');
  text(phase2(ii(1),1),phase2(ii(1),2),'\rightarrow   ','HorizontalAlignment','right');

  subplot(1,2,2);
  plot(t(ii) - t(ii(1)),cf(ii),'*');
  title(sprintf('relative distances from time, t = %5.2f day',t(ii(1))));
  xlabel('time (day)');
  ylabel('r_{ij} / (R_i + R_j)');

  if (save)
      if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
          mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
      end
      cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
      set(gcf,'PaperPositionMode','auto');
      print('-dpng',strcat('PosCf',int2str(i)));
  end

end