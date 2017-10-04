function plot_Wall_counters(subplot1,N_X,X_C,X_L,Option)


Limits=Option.limits;
rho=Option.rho;

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

X_mu=(X_C+X_L)/2;

Wall=-transpose(N_X)*X_mu;
for ii=1:size(X2,1),
    for jj=1:size(X2,2)
        
        X=[X1(ii,jj);X2(ii,jj)];
        
        if (Option.Onsurface==1)
            Walla(ii,jj)=transpose(N_X)*(X+Wall*N_X);
        else
            Walla(ii,jj)=transpose(N_X)*(X+Wall*N_X)+(X-X_C)'*(X-X_L+rho*(X_L-X_C)/((X_L-X_C)'*(X_L-X_C)));
        end
        
        
        if  rho<(Walla(ii,jj))
            Walla(ii,jj)=rho;
        end
    end
end
%  clim=[-2 1];
contourf(X1,X2,Walla)
colormap(hot)
set(subplot1,'CLim');
set(subplot1,'BoxStyle','full','FontSize',20,'Layer','top',...
    'TickLabelInterpreter','latex');
colorbar('peer',subplot1);
hold on
