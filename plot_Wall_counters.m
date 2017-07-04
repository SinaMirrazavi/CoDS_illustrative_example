function plot_Wall_counters(subplot1,Poly,X_free,X_C,X_L,Limits)

hold(subplot1,'on');
box(subplot1,'on');
grid(subplot1,'on');
set(subplot1,'FontSize',20);
xlabel('X(1)','Interpreter','latex');
ylabel('X(2)','Interpreter','latex');
ylim([Limits(3) Limits(4)]);
xlim([Limits(1) Limits(2)]);

X1=[Limits(1):0.1:Limits(2)];
X2=[Limits(3):0.1:Limits(4)]';
X1=repmat(X1,size(X2,1),1);
X2=repmat(X2,1,size(X1,2));


Walla=zeros(size(X2));

Handle_sign=sign(-X_free(2,1)+Poly(1)*X_free(1,1)+Poly(2));
X_mu=(X_C+X_L)/2;
signal_i=eye(2);
Q_2=(X_L-X_C);
for ii=1:size(X2,1),
    for jj=1:size(X2,2)
          Walla(ii,jj)=((5-exp(-transpose([X1(ii,jj);X2(ii,jj)]-X_mu)*signal_i*([X1(ii,jj);X2(ii,jj)]-X_mu)))/(1+exp(-transpose([X1(ii,jj);X2(ii,jj)]-X_mu)*signal_i*([X1(ii,jj);X2(ii,jj)]-X_mu)))-2)*...
                             (0.1*Handle_sign*(-X2(ii,jj)+Poly(1)*X1(ii,jj)+Poly(2))+exp(-10000*transpose(X_L-[X1(ii,jj);X2(ii,jj)])*Q_2));
    if  1<(Walla(ii,jj))
         Walla(ii,jj)=1;
    end
    end
end
 clim=[-2 1]; 
contourf(X1,X2,Walla)
colormap(hot)
 set(subplot1,'CLim',clim);
 set(subplot1,'BoxStyle','full','CLim',clim,'FontSize',20,'Layer','top',...
     'TickLabelInterpreter','latex');
 colorbar('peer',subplot1);
hold on
