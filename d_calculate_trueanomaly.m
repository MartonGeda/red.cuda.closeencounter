%% calculate true anomaly, angular coordinate

E01 = zeros(size(params,1),1);      %initial excentric anomaly from smith formula for body1
E02 = zeros(size(params,1),1);      %initial excentric anomaly from smith formula for body2
E1 = zeros(size(params,1),1);       %excentric anomaly for body1
E2 = zeros(size(params,1),1);       %excentric anomaly for body2

H01 = zeros(size(params,1),1);      %initial hyperbolic anomaly from burkhardt-dunby formula for body1
H02 = zeros(size(params,1),1);      %initial hyperbolic anomaly from burkhardt-dunby formula for body2
H1 = zeros(size(params,1),1);       %hyperbolic anomaly for body1
H2 = zeros(size(params,1),1);       %hyperbolic anomaly for body2


v1 = zeros(size(params,1),1);       %true anomaly for body1
v2 = zeros(size(params,1),1);       %true anomaly for body2

for i=1:size(params,1)
    if (h1(i) < 0)
        E01(i) = oe1(i,6) + oe1(i,2) * (sin(oe1(i,6))) / (1.0 - sin(oe1(i,6) + oe1(i,2)) + sin(oe1(i,6)));
        err1 = abs(E1(i) - E01(i));
        while ( 1 )     %Newton iteration
            E1(i) = E01(i) - (E01(i) - oe1(i,2) * sin(E01(i)) - oe1(i,6)) / (1.0 - oe1(i,2) * cos(E01(i)));
            err1 = abs(E1(i) - E01(i));
            if (err1 < 1e-13)
                break;
            end
            if (isnan(err1))
               break; 
            end
            E01(i) = E1(i);
        end
        v1(i) = 2.0 * atan(sqrt((1.0 + oe1(i,2)) / (1.0 - oe1(i,2))) * tan(E1(i) / 2.0));
    else
        H01(i) = log(2*oe1(i,6)/oe1(i,2) + 1.8);
        err1 = abs(H1(i) - H01(i));
        while ( 1 )     %Newton iteration
            H1(i) = H01(i) - (oe1(i,2) * sinh(H01(i)) - H01(i) - oe1(i,6)) / (oe1(i,2) * cosh(H01(i)) - 1.0);
            err1 = abs(H1(i) - H01(i));
            if (err1 < 1e-13)
                break;
            end
            if (isnan(err1))
               break; 
            end
            H01(i) = H1(i);
        end
        v1(i) = 2.0 * atan(sqrt((oe1(i,2) + 1.0) / (oe1(i,2) - 1.0)) * tanh(H1(i) / 2.0));       
    end
    
    if (h2(i) < 0)
        E02(i) = oe2(i,6) + oe2(i,2) * (sin(oe2(i,6))) / (1.0 - sin(oe2(i,6) + oe2(i,2)) + sin(oe2(i,6)));
        err2 = abs(E2(i) - E02(i));
        while ( 1 )     %Newton iteration
            E2(i) = E02(i) - (E02(i) - oe2(i,2) * sin(E02(i)) - oe2(i,6)) / (1.0 - oe2(i,2) * cos(E02(i)));
            err2 = abs(E2(i) - E02(i));
            if (err2 < 1e-13)
                break;
            end
            if (isnan(err2))
               break; 
            end
            E02(i) = E2(i);
        end  
        v2(i) = 2.0 * atan(sqrt((1.0 + oe2(i,2)) / (1.0 - oe2(i,2))) * tan(E2(i) / 2.0));
    else
        H02(i) = log(2*oe2(i,6)/oe2(i,2) + 1.8);
        err2 = abs(H2(i) - H02(i));
        while ( 1 )     %Newton iteration
            H2(i) = H02(i) - (oe2(i,2) * sinh(H02(i)) - H02(i) - oe2(i,6)) / (oe2(i,2) * cosh(H02(i)) - 1.0);
            err2 = abs(H2(i) - H02(i));
            if (err2 < 1e-13)
                break;
            end
            if (isnan(err2))
               break; 
            end
            H02(i) = H2(i);
        end 
        v2(i) = 2.0 * atan(sqrt((oe2(i,2) + 1.0) / (oe2(i,2) - 1.0)) * tanh(H2(i) / 2.0));      
    end
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
