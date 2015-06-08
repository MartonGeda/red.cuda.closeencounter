function [x, y, z, vx, vy, vz] = twobodyproblem (mu, x0, y0, z0, vx0, vy0, vz0, t0, t , maxerr)
% two body problem solver
% initial positions (x0, y0, z0), velocities (vx0, vy0, vz0), time (t0)
% calculated positions(x, y, z), velocities(vx, vy, vz) in time (t)

if (nargin == 9)
   maxerr = 1e-13; 
end

r02 = x0^2 + y0^2 + z0^2;
r0 = sqrt(r02);
v02 = vx0^2 + vy0^2 + vz0^2;

h = v02/2.0 - (mu/r0);

cx = y0*vz0 - z0*vy0;
cy = z0*vx0 - x0*vz0; 
cz = x0*vy0 - y0*vx0;
c = sqrt(cx^2 + cy^2 + cz^2);

oe = phase2oe(mu,x0,y0,z0,vx0,vy0,vz0);
a = oe(1);
e = oe(2);
i = oe(3);
w = oe(4);
Om = oe(5);
M0 = oe(6);

PQ = [cos(w)*cos(Om) - sin(w)*sin(Om)*cos(i), -sin(w)*cos(Om) - cos(w)*sin(Om)*cos(i); ...
      cos(w)*sin(Om) + sin(w)*cos(Om)*cos(i), -sin(w)*sin(Om) + cos(w)*cos(Om)*cos(i); ...
      sin(w)*sin(i)                         , cos(w)*sin(i); ...
     ];

for k=1:3
    for l=1:2 
        if (abs(PQ(k,l)) < 1e-15)
            PQ(k,l) = 0;
        end
    end
end
 
% Kepler equation solver

j=1; % loop counter
err0 = 0; % initial error (must be set to 0)
if (h < 0)
    n = sqrt(mu * a^-3);
    M = wrapTo2Pi(M0 + n * (t - t0));
    E0 = M + e * (sin(M)) / (1.0 - sin(M + e) + sin(M));
    while ( 1 )     %Newton iteration
        E1 = E0 - (E0 - e * sin(E0) - M) / (1.0 - e * cos(E0));
        err1 = abs(E1 - E0);
        if (err1 < maxerr)
            break;
        end
        if (isnan(err1))
           break; 
        end
        if ((err1 - err0) == 0)
            error('Kepler equation does not converge with %g error rate.\nNumber of loops reached: %d',maxerr, j);
        end
        E0 = E1;
        err0 = err1;
        j = j+1;
    end
    v = 2.0 * atan(sqrt((1.0 + e) / (1.0 - e)) * tan(E1 / 2.0));
else
    n = mu^2 / h^3 * (e^2 - 1)^1.5;
    M = wrapTo2Pi(M0 + n * (t - t0));
    H0 = log(2*M/e + 1.8);
    while ( 1 )     %Newton iteration
        H1 = H0 - (e * sinh(H0) - H0 - M) / (e * cosh(H0) - 1.0);
        err1 = abs(H1 - H0);
        if (err1 < maxerr)
            break;
        end
        if (isnan(err1))
           break; 
        end
        if ((err1 - err0) == 0)
            error('Kepler equation does not converge with %g error rate.\nNumber of loops reached: %d',maxerr, j);
        end        
        H0 = H1;
        err0 = err1;
        j = j+1;        
    end
    v = 2.0 * atan(sqrt((e + 1.0) / (e - 1.0)) * tanh(H1 / 2.0));       
end

p = c^2 / mu;
r = p / (1 + e*cos(v));

kszi = r * cos(v);
eta = r * sin(v);
vkszi = -sin(v) * sqrt(mu/p);
veta = (e + cos(v)) * sqrt(mu/p);

pos = PQ * [kszi; eta];
vel = PQ * [vkszi; veta];

x = pos(1);
y = pos(2);
z = pos(3);

vx = vel(1);
vy = vel(2);
vz = vel(3);

end