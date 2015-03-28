function out = draw_arrow(p1,p2,hs)
% accepts two [x y] coords and one double headsize

        line([p1(1) p2(1)],[p1(2) p2(2)],'Color','k');
        
        z1 = hs*(p1-p2)/2.5;

        theta = 22.5*pi/180;
        theta1 = -1*22.5*pi/180;
        rotMatrix = [cos(theta)  -sin(theta) ; sin(theta)  cos(theta)];
        rotMatrix1 = [cos(theta1)  -sin(theta1) ; sin(theta1)  cos(theta1)];
   
        z2 = z1*rotMatrix;
        z3 = z1*rotMatrix1;
        c1 = p2;
        c2 = c1 + z2;
        c3 = c1 + z3;
        hold on;
        fill([c1(1) c2(1) c3(1)],[c1(2) c2(2) c3(2)],[0 0 0]);  
        
end