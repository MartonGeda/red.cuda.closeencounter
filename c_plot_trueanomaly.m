%% True anomaly
for i = 1:5
    if (i == 1)
        figure('Name',int2str(1),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        plot(t(1:pos(1)) - t(1),v1(1:pos(1)),'*',t(1:pos(1)) - t(1),v2(1:pos(1)),'*');
        title(sprintf('time, t = %5.2f day',t(1)));
        xlabel('time (day)');
        ylabel('v (rad)');
        legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
    else
        figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        plot(t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),v1((pos(i-1)+1):pos(i)),'*',t((pos(i-1)+1):pos(i)) - t(pos(i-1)+1),v2((pos(i-1)+1):pos(i)),'*');
        title(sprintf('time, t = %5.2f day',t(pos(i-1)+1))); 
        xlabel('time (day)');
        ylabel('v (rad)');       
        legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
    end
end