function [DDX,DX,X,F,Time]=simulate_modulated_system(A,N_X,Poly,X_initial,X_target,X_free,X_C,X_L,option)



disp('Simulating the modulated dynamical system from the initial positions to the target. It might take some time, please be patient.')

for j=1:size(X_initial,2)
    [DDX{j},DX{j},X{j},F{j},Time{j}] = simulate(X_initial(:,j),A,X_target,X_free,X_C,X_L,Poly,N_X,option);
end

end

function [DDX,DX,X,F,Time]=simulate(X_initial,A,X_target,X_free,X_C,X_L,Poly,N_X,option)
Deltat=option.Deltat;
F_d=option.F_d;
delta_dx=option.delta_dx;
rho=option.rho;
omega=option.omega;
nu=option.nu;
T=option.Tfinal;
Limits=option.limits;

Handle_sign=sign(-X_free(2,1)+Poly(1)*X_free(1,1)+Poly(2));
sizeT=int64(T/Deltat);
DDX=zeros(size(X_initial,1)/2,sizeT+1);DX=zeros(size(X_initial,1)/2,sizeT+1);
X=zeros(size(X_initial,1)/2,sizeT+1);
F=zeros(size(X_initial,1)/2,sizeT+1);
Time=zeros(sizeT+1,1);

q2=[-N_X(2);N_X(1)];
Q=[N_X q2];
Qinv=inv(Q);

counter=1;
A_2=A(3:4,3:4);
A_1=A(3:4,1:2);

% close all
% subplot1 = subplot(1,1,1);
% plot_Wall_counters(subplot1,N_X,X_C,X_L,rho,Limits)
% h2=plot(X_target(1,1),X_target(2,1),'MarkerFaceColor',[0 0 1],...
%     'MarkerEdgeColor','none',...
%     'MarkerSize',30,...
%     'Marker','pentagram',...
%     'LineWidth',5,...
%     'LineStyle','none');
% hold on
% h1=plot(X_initial(1,:),X_initial(2,:),...
%     'MarkerFaceColor',[0.466666668653488 0.674509823322296 0.18823529779911],...
%     'MarkerEdgeColor','none',...
%     'MarkerSize',30,...
%     'Marker','hexagram',...
%     'LineWidth',5,...
%     'LineStyle','none');
% X_wall(1,:) = linspace(Limits(1,1),Limits(1,2),10^5);
% X_wall(2,:) = Poly(1)*X_wall+Poly(2);
% h3=plot(X_wall(1,:),X_wall(2,:),'LineWidth',4,...
%     'LineStyle','--',...
%     'Color',[0 0 0]);
% hold on
% h4=plot(X_C(1,1),X_C(2,1),...
%     'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
%     'MarkerSize',30,...
%     'Marker','^',...
%     'LineStyle','none');
% h5=plot(X_L(1,1),X_L(2,1),...
%     'MarkerFaceColor',[1 0 0],...
%     'MarkerSize',30,...
%     'Marker','v',...
%     'LineStyle','none');

X(:,1)=X_initial(1:2,1);
DX(:,1)=X_initial(3:4,1);
X_mu=(X_C+X_L)/2;

Wall=-transpose(N_X)*X_mu;

X_C=X_C-0.001*N_X;
X_l=X_L-0.001*N_X;



while ((counter<sizeT))
    
    if (option.Onsurface==1)
        Gamma=transpose(N_X)*(X(:,counter)+Wall*N_X);
    else
        Gamma=transpose(N_X)*(X(:,counter)+Wall*N_X)+(X(:,counter)-X_C)'*(X(:,counter)-X_L+rho*(X_L-X_C)/((X_L-X_C)'*(X_L-X_C)));
    end
    
    f_x=SE(DX(:,counter),X(:,counter),A_1,A_2,X_target);
    
    [M,~]=Modulation(Gamma,f_x,DX(:,counter),X(:,counter),X_C,X_l,N_X,q2,Wall,Q,Qinv,option);
    
    if (N_X'*X(:,counter)+Wall <=0)
        F(:,counter)=(exp(-10000*(Handle_sign*(-X(2,counter)+Poly(1)*X(1,counter)+Poly(2))))-1)*N_X;
        %         X(:,counter)=(X(:,counter)-X_L)'*(Q_2)*Q_2/(norm(Q_2)^2)+X_L;
    end
    DDX(:,counter+1)= M*f_x+F(:,counter);
    DX(:,counter+1)=DX(:,counter)+DDX(:,counter+1)*Deltat;
    X(:,counter+1)=X(:,counter)+DX(:,counter+1)*Deltat;
    Time(counter+1)=Time(counter)+Deltat;
    %     if (rem(counter,100)==0)
    %         plot(X(1,counter),X(2,counter),'.','Color',[0 0.447058826684952 0.74117648601532]);
    %         pause(0.001)
    %         hold on
    %     end
    if (norm(X(:,counter+1)-X_target)<0.1)
        break
    end
    
    counter=counter+1;
end
DDX(:,counter-1:end)=[];
DX(:,counter-1:end)=[];
X(:,counter-1:end)=[];
F(:,counter-1:end)=[];
Time(counter-1:end)=[];



end
function f_x = SE(DX,X,A_1,A_2,X_target)

f_x=A_2*DX+A_1*(X-X_target);

end

function [M,Lambda] = Modulation(Gamma,f_x,DX,X,X_C,X_l,N_X,q2,Wall,Q,Qinv,Option)
epsilon=10;
DX_G=N_X'*DX;
DX_q=q2'*DX;
Lambda=zeros(2,2);

delta_dx=Option.delta_dx;
rho=Option.rho;
omega=Option.omega;
nu=Option.nu;


f1=transpose(f_x)*N_X/(transpose(f_x)*f_x);
f2=transpose(f_x)*q2/(transpose(f_x)*f_x);

X=X+Wall*N_X;
Wall=0;
if (rho<=Gamma)
    Lambda(1,1) =((-2*omega^(-1)*DX_G-omega^(-2)*transpose(N_X)*(X-X_C))*f1-1)*exp(epsilon*(rho-Gamma))+1;
    Lambda(1,2) =((-2*omega^(-1)*DX_G-omega^(-2)*transpose(N_X)*(X-X_C))*f2)*exp(epsilon*(rho-Gamma));
    Lambda(2,1) =((-2*omega^(-1)*DX_q-omega^(-2)*transpose(q2)*(X-X_C))*f1)*exp(epsilon*(rho-Gamma));
    Lambda(2,2) =((-2*omega^(-1)*DX_q-omega^(-2)*transpose(q2)*(X-X_C))*f2-1)*exp(epsilon*(rho-Gamma))+1;
elseif (0<transpose(N_X)*X+Wall)&&(Gamma<rho)
    if (DX_G<delta_dx)
        Lambda(1,1) =-omega^(-1)*(DX_G-(delta_dx+nu))*f1;
        Lambda(1,2) =-omega^(-1)*(DX_G-(delta_dx+nu))*f2;
    elseif (((delta_dx<=DX_G))&&(DX_G<=0))
        Lambda(1,1) =((transpose(N_X)*X+nu*omega)*DX_G-transpose(N_X)*X*delta_dx)/(omega^(2)*delta_dx)*f1;
        Lambda(1,2) =((transpose(N_X)*X+nu*omega)*DX_G-transpose(N_X)*X*delta_dx)/(omega^(2)*delta_dx)*f2;
    else
        Lambda(1,1) =((-2*omega^(-1)*DX_G-omega^(-2)*transpose(N_X)*(X-X_C))*f1);
        Lambda(1,2) =((-2*omega^(-1)*DX_G-omega^(-2)*transpose(N_X)*(X-X_C))*f2);
    end
    Lambda(2,1) =((-2*omega^(-1)*DX_q-omega^(-2)*transpose(q2)*(X-X_C))*f1);
    Lambda(2,2) =((-2*omega^(-1)*DX_q-omega^(-2)*transpose(q2)*(X-X_C))*f2);
elseif (transpose(N_X)*X+Wall<=0) 
    if (Option.Onsurface==0)
        X_L=2*X_l-X_C;
    else
        X_L=X_l;
    end  
    Lambda(1,1) =((-2*omega^(-1)*DX_G-omega^(-2)*transpose(N_X)*(X-X_L))*f1);
    Lambda(1,2) =((-2*omega^(-1)*DX_G-omega^(-2)*transpose(N_X)*(X-X_L))*f2);
    Lambda(2,1) =((-2*omega^(-1)*DX_q-omega^(-2)*transpose(q2)*(X-X_L))*f1);
    Lambda(2,2) =((-2*omega^(-1)*DX_q-omega^(-2)*transpose(q2)*(X-X_L))*f2);
end

%
%
% if (1<=Gamma)
%     Lambda(1,1) = (1-exp(-(1/epsilon)*(Gamma-1)))/(1+exp(-(1/epsilon)*(Gamma-1)));
% end
% if (((DX_G<delta_dx)&&((0<Gamma)&&(Gamma<1)))&&( Contact==0))
%     Lambda(1,1) = 10*(1-Gamma)*(delta_dx-DX_G)/(abs(Gamma)*N_X'*f_x);
% end
% if (((DX_G<0)&&((delta_dx<=DX_G)))&&((0<Gamma)&&(Gamma<1)))
%     Lambda(1,1) =-(1-Gamma)*F_d*exp(-Gamma/epsilon);
% end
% if ((0<=DX_G)&&((0<Gamma)&&(Gamma<1)))
%     Lambda(1,1) =  -(1-Gamma)*(DX_G+exp(-Gamma/epsilon))*F_d/(N_X'*f_x);
% end
% if ((Gamma<=0))
%     Lambda(1,1) =  -F_d/(N_X'*f_x);
% end
% if (1<=Gamma)
%     Lambda(2,2)=Lambda(1,1);
% elseif ((0<Gamma)&&(Gamma<1)&&( Contact==0))
%     Lambda(2,2)= 10*(1-Gamma)*(-(1/(Gamma+0.001))*(q2'*DX*N_X'*(X-X_C)-N_X'*DX*q2'*(X-X_C)))/(N_X'*(X-X_C)*q2'*f_x);
% elseif ((Gamma<=0)&&( Contact==0))
%     CONTACT=1;
%     Lambda(2,2)=1;
% elseif ( Contact==1)
%     Lambda(2,2)=1;
% end
% %     if norm(Lambda)>1000
% %         keyboard
% %     end
M=Q*Lambda*Qinv;

end
