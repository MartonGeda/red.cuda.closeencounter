%% calculate true anomaly, angular coordinate

E01 = zeros(length(params),1);      %initial excentric anomaly from smith formula for body1
E02 = zeros(length(params),1);      %initial excentric anomaly from smith formula for body2
E1 = zeros(length(params),1);       %excentric anomaly for body1
E2 = zeros(length(params),1);       %excentric anomaly for body2
v1 = zeros(length(params),1);       %true anomaly for body1
v2 = zeros(length(params),1);       %true anomaly for body2

for i=1:length(params)   
    E01(i) = oe1(i,6) + oe1(i,2) * (sin(oe1(i,6))) / (1.0 - sin(oe1(i,6) + oe1(i,2)) + sin(oe1(i,6)));
    err1 = abs(E1(i) - E01(i));
    E02(i) = oe2(i,6) + oe2(i,2) * (sin(oe2(i,6))) / (1.0 - sin(oe2(i,6) + oe2(i,2)) + sin(oe2(i,6)));
    err2 = abs(E2(i) - E02(i));
    while ( 1 )     %Newton iteration
        E1(i) = E01(i) - (E01(i) - oe1(i,2) * sin(E01(i)) - oe1(i,6)) / (1.0 - oe1(i,2) * cos(E01(i)));
        err1 = abs(E1(i) - E01(i));
        E2(i) = E02(i) - (E02(i) - oe2(i,2) * sin(E02(i)) - oe2(i,6)) / (1.0 - oe2(i,2) * cos(E02(i)));
        err2 = abs(E2(i) - E02(i));
        if (err1 < 1e-14 && err2 < 1e-14)
            break;
        end
        if (isnan(err1) || isnan(err2))
           break; 
        end
        E01 = E1;
        E02 = E2;
    end
    
    v1(i) = 2.0 * atan(sqrt((1.0 + oe1(i,2)) / (1.0 - oe1(i,2))) * tan(E1(i) / 2.0));
    v2(i) = 2.0 * atan(sqrt((1.0 + oe2(i,2)) / (1.0 - oe2(i,2))) * tan(E2(i) / 2.0));
end

u1 = v1 + oe1(:,4);     %angle from line of nodes for body1
u2 = v2 + oe2(:,4);     %angle from line of nodes for body2

for i=1:length(u1)
   if(abs(u1(i)) >= 2*pi)
      u1(i) = u1(i) - pi; 
   end
    if(abs(u2(i)) >= 2*pi)
      u2(i) = u2(i) - pi; 
   end
end
