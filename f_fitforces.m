%% Fit Lorentzian curve to the forces between the bodies
tic;
savepic = true;

rsquare = zeros(N,1);
aa = zeros(N,1);
bb = zeros(N,1);
cc = zeros(N,1);
dd = zeros(N,1);
myfittype = fittype('a*c^2/((x-b)^2 + c^2) + d','independent',{'x'},'coefficients',{'a','b','c','d'});

fff = @(a,b,c,d,x)((d*x.^2)/2 - (a*c^2.*log(b^2 - 2*b*x + c^2 + x.^2))/2 - a*b*c.*atan(-(b - x)/c) + a*c*x.*atan(-(b - x)/c));

for i=1:N
   if dpos(i) > 4
       if i == 1
          ii = 1:pos(1);
          figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
       else
          ii = pos(i-1)+1:pos(i);    
       end

       %figure('Name',int2str(i),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

       [aa(i), iii] = max(fij(ii));
       if i == 1
            bb(1) = t(iii) - t(ii(1));
       else
            bb(i) = t(iii + pos(i-1))  - t(ii(1));
       end
       [~, iii] = min(abs(fij(ii) - aa(i)/2));
       if i == 1
            cc(1) = abs(bb(i) - (t(iii) - t(ii(1))));
       else
            cc(i) = abs(bb(i) - (t(iii + pos(i-1))  - t(ii(1))));
       end

       [ff,gof,output] = fit(t(ii) - t(ii(1)),fij(ii),myfittype,'Startpoint',[aa(i) bb(i) cc(i) 0]);
       rsquare(i) = gof.rsquare;
       dd(i) = ff.d;

       %plot(t(ii) - t(ii(1)),d(ii)*m1(1),'*',t(ii) - t(ii(1)), fff(aa(i),bb(i),cc(i),0,t(ii) - t(ii(1))));
       
       subplot(2,2,1);       
       plot(t(ii) - t(ii(1)),fx(ii),'*',t(ii) - t(ii(1)),fy(ii),'*',t(ii) - t(ii(1)),fij(ii),'*',t(ii) - t(ii(1)),ff(t(ii) - t(ii(1))));
       title('forces between the bodies');
       xlabel('time (day)');
       ylabel('force (M_{S}AU/day^2)');
       legend('F_x','F_y','F_{ij}','F_{ij} fit');
       
       subplot(2,2,2);
       plot(t(ii) - t(ii(1)),fsun(ii,1),'*',t(ii) - t(ii(1)),fsun(ii,2),'*');
       title('|F_{Sun}|');
       xlabel('time (day)');
       ylabel('force (M_{S}AU/day^2)');
       
       subplot(2,2,3);
       plot(t(ii) - t(ii(1)),fsunx(ii,1),'*',t(ii) - t(ii(1)),fsunx(ii,2),'*');
       title('F_{Sun}_x');
       xlabel('time (day)');
       ylabel('force (M_{S}AU/day^2)');
       
       subplot(2,2,4);
       plot(t(ii) - t(ii(1)),fsuny(ii,1),'*',t(ii) - t(ii(1)),fsuny(ii,2),'*');
       title('F_{Sun}_y');
       xlabel('time (day)');
       ylabel('force (M_{S}AU/day^2)');       
       
       lh = legend(int2str(id1(pos(i))),int2str(id2(pos(i))));
       p = get(lh,'Position');
       p(1) = 0.9335;
       p(2) = 0.940;
       set(lh,'Position',p);
       
       [fmin,imin] = min(fij(ii));
       [fmax,imax] = max(fij(ii));
       if i~=1
           imin = imin + pos(i-1);
           imax = imax + pos(i-1);
       end

       suptitle(sprintf('time t = %5.2f day, time of event \\Deltat = %1.3f day, angle of intersection \\Phi = %2.2f°, cf_{min} = %1.4f  \n ratio of the min forces F_{ij} : F_s : F_k = %g : %1.1g : %1.1g \t ratio of the max forces F_{ij} : F_s : F_k = %g : %1.1g : %1.1g',t(ii(1)),timeofce(i),alpha(i),Cf(i),1,fsun(imin,1)/fmin,forces(indx2(imin),3)/fmin,1,fsun(imax,1)/fmax,forces(indx2(imax),3)/fmax ));  

       if(savepic)
    %             if(~exist(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))),'dir'))
    %                 mkdir(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
    %             end
    %             cd(strcat(currentdir,'\Events\',strcat('CloseEn',int2str(i))));
           set(gcf,'PaperPositionMode','auto');
           print('-dpng',strcat('Forces',int2str(i)));  
       end
   end
    
end

toc;