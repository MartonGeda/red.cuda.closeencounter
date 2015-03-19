%% velocities, collision factor

for i=1:N
    if (i == 1)
        figure();
        subplot(1,2,1);
        plot(phase1(1:pos(1),4),phase1(1:pos(1),5),'*',phase2(1:pos(1),4),phase2(1:pos(1),5),'*');
        title('velocities of close encounter bodies');
        xlabel('x (AU)');
        ylabel('y (AU)');        
        
        subplot(1,2,2);
        plot(t(1:pos(1)),cf(1:pos(1)),'*');
        title('distance between the close encounter bodies');
        xlabel('time (day)');
        ylabel('radii enhance factor');
    else 
        figure();
        subplot(1,2,1);
        plot(phase1((pos(i-1)+1):pos(i),4),phase1((pos(i-1)+1):pos(i),5),'*',phase2((pos(i-1)+1):pos(i),4),phase2((pos(i-1)+1):pos(i),5),'*');
        title('velocities of close encounter bodies');
        xlabel('x (AU)');
        ylabel('y (AU)');         
        
        subplot(1,2,2);
        plot(t((pos(i-1)+1):pos(i)),cf(pos(i-1)+1:pos(i)),'*');
        title('distance between the close encounter bodies');
        xlabel('time (day)');
        ylabel('radii enhance factor');     
    end
end