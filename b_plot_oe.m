%% Orbital Elements, time

for i=1:N
    if (i == 1)
        figure();
        subplot(2,2,1);
        plot(t(1:pos(1)),oe1(1:pos(1),1),'*',t(1:pos(1)),oe2(1:pos(1),1),'*');
        title('semimajor axis');
        xlabel('time (day)');
        ylabel('a (AU)');
        legend(int2str(id1(pos(1))),int2str(id2(pos(1))));
        
        subplot(2,2,2);
        plot(t(1:pos(1)),oe1(1:pos(1),2),'*',t(1:pos(1)),oe2(1:pos(1),2),'*');
        title('eccentricity');
        xlabel('time (day)');
        ylabel('e');
        
        subplot(2,2,3);
        plot(t(1:pos(1)),oe1(1:pos(1),4),'*',t(1:pos(1)),oe2(1:pos(1),4),'*');
        title('argument of pericenter');
        xlabel('time (day)');
        ylabel('w (rad)');
         
        subplot(2,2,4);
        plot(t(1:pos(1)),oe1(1:pos(1),6),'*',t(1:pos(1)),oe2(1:pos(1),6),'*');
        title('mean anomaly');
        xlabel('time (day)');
        ylabel('M (rad)');
                  
    else 
        figure();
        subplot(2,2,1);
        plot(t((pos(i-1)+1):pos(i)),oe1((pos(i-1)+1):pos(i),1),'*',t((pos(i-1)+1):pos(i)),oe2((pos(i-1)+1):pos(i),1),'*');
        title('semimajor axis');
        xlabel('time (day)');
        ylabel('a (AU)');
        legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
        
        subplot(2,2,2);
        plot(t((pos(i-1)+1):pos(i)),oe1((pos(i-1)+1):pos(i),2),'*',t((pos(i-1)+1):pos(i)),oe2((pos(i-1)+1):pos(i),2),'*');
        title('eccentricity');
        xlabel('time (day)');
        ylabel('e');
        
        subplot(2,2,3);
        plot(t((pos(i-1)+1):pos(i)),oe1((pos(i-1)+1):pos(i),4),'*',t((pos(i-1)+1):pos(i)),oe2((pos(i-1)+1):pos(i),4),'*');
        title('argument of pericenter');
        xlabel('time (day)');
        ylabel('w (rad)');
        
        subplot(2,2,4);
        plot(t((pos(i-1)+1):pos(i)),oe1((pos(i-1)+1):pos(i),6),'*',t((pos(i-1)+1):pos(i)),oe2((pos(i-1)+1):pos(i),6),'*');
        title('mean anomaly');
        xlabel('time (day)');
        ylabel('M (rad)');     
    end
end