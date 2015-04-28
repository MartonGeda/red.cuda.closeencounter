function [ oe ] = phase2oe( mu, x, y, z, vx, vy, vz )
% calculate orbital elements from phases
%   Detailed explanation goes here
v2 = vx.^2 + vy.^2 + vz.^2;
%v = sqrt(v2);
r2 = x.^2 + y.^2 + z.^2;
r = sqrt(r2);

rv = x.*vx + y.*vy + z.*vz;

h = v2/2.0 - (mu./r);

cx = y.*vz - z.*vy;
cy = z.*vx - x.*vz; 
cz = x.*vy - y.*vx;
c = sqrt(cx.^2 + cy.^2 + cz.^2);

lx = -mu./r .* x + vy.*cz - vz.*cy;
ly = -mu./r .* y + vz.*cx - vx.*cz;
lz = -mu./r .* z + vx.*cy - vy.*cx;
l = sqrt(lx.^2 + ly.^2 + lz.^2);

a = -mu./(2.0*h);
e = sqrt(1.0 + 2.0*c.^2.*h./mu.^2);

cosi = cz./c;
sini = sqrt(cx.^2 + cy.^2)./c;
i = acos(cosi);
Om = zeros(length(i),1);
    for j=1:length(i)
        if i(j) < 1e-14
            i(j) = 0.0; 
        end
        if i(j) > (pi - 1e-14)
            i(j) = pi;
        end
        if (i(j) ~= 0.0 && i(j) ~= pi)
            Om(j) = wrapTo2Pi(atan2(-cy(j)./(c(j).*sini(j)) , cx(j)./(c(j).*sini(j)))); 
        end
    end

E = zeros(length(h),1);
shH = zeros(length(h),1);
H = zeros(length(h),1);
if e ~= 0
    om = wrapTo2Pi(atan2((-lx.*sin(Om) + ly.*cos(Om))./(l.*cosi), (lx.*cos(Om) + ly.*sin(Om))./l ));
    for j=1:length(h)
       if h(j) >= 0.0
           shH(j) = rv(j) / ((a(j)*mu)^2 / c(j)^3 * e(j) * (e(j)^2 - 1)^1.5);
           H(j) = asinh(shH(j));
       else
           E(j) = wrapTo2Pi(atan2(rv(j) / (sqrt(mu*a(j)) * e(j)), (1-r(j)/a(j))/e(j)));
       end
    end   
else
    om = zeros(length(h),1);
    E = wrapTo2Pi(atan2(y,x));
end

M = zeros(length(h),1);
for j = 1:length(h)
    if h(j) >=0
       M(j) = e(j)*shH(j) - H(j); 
    else
       M(j) = wrapTo2Pi(E(j) - e(j)*sin(E(j)));
    end
end

oe = [a e i om Om M];

end

