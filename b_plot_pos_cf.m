%% plot positions, radii enhance factor

for i = 1:N
   if i == 1
      figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
      subplot(1,2,1);
      plot(phase1(1:pos(1),1),phase1(1:pos(1),2),'*',phase2(1:pos(1),1),phase2(1:pos(1),2),'*');
      title('positions of close encounter bodies');
      xlabel('x (AU)');
      ylabel('y (AU)');
      lh = legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
      set(lh,'Box','off');
      text(phase1(1,1),phase1(1,2),'   \leftarrow');
      text(phase2(1,1),phase2(1,2),'\rightarrow   ','HorizontalAlignment','right');
      
      subplot(1,2,2);
      plot(t(1:pos(1)) - t(1),cf(1:pos(1)),'*');
      title(sprintf('relative distances from time, t = %5.2f day',t(1)));
      xlabel('time (day)');
      ylabel('radii enhance factor');
   else
      figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
      subplot(1,2,1);
      plot(phase1(pos(i-1)+1:pos(i),1),phase1(pos(i-1)+1:pos(i),2),'*',phase2(pos(i-1)+1:pos(i),1),phase2(pos(i-1)+1:pos(i),2),'*');
      title('positions of close encounter bodies');
      xlabel('x (AU)');
      ylabel('y (AU)');
      lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
      set(lh,'Box','off');
      text(phase1(pos(i-1)+1,1),phase1(pos(i-1)+1,2),'   \leftarrow');
      text(phase2(pos(i-1)+1,1),phase2(pos(i-1)+1,2),'\rightarrow   ','HorizontalAlignment','right');
      
      
      subplot(1,2,2);
      plot(t(pos(i-1)+1:pos(i)) - t(pos(i-1)+1),cf(pos(i-1)+1:pos(i)),'*');
      title(sprintf('relative distances from time, t = %5.2f day',t(pos(i-1)+1)));
      xlabel('time (day)');
      ylabel('radii enhance factor');       
   end
end