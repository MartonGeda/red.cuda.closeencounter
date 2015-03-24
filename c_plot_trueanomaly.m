%% True anomaly
for i = 1:N
    if (i == 1)
        figure();
        plot(t(1:pos(1)),v1(1:pos(1)),'*',t(1:pos(1)),v2(1:pos(1)),'*');
        title('true anomaly');
        xlabel('time (day)');
        ylabel('v (rad)');
        legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
    else
        figure();
        plot(t((pos(i-1)+1):pos(i)),v1((pos(i-1)+1):pos(i)),'*',t((pos(i-1)+1):pos(i)),v2((pos(i-1)+1):pos(i)),'*');
        title('true anomaly');
        xlabel('time (day)');
        ylabel('v (rad)');       
        legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
    end
end