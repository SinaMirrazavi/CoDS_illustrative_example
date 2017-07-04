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
T=option.Tfinal;

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



X(:,1)=X_initial(1:2,1);
DX(:,1)=X_initial(3:4,1);
X_mu=(X_C+X_L)/2;
signal_i=eye(2);
CONTACT=0;
while ((counter<sizeT))
    
    Q_2=(X_L-X_C);
    Gamma=((5-exp(-transpose(X(:,counter)-X_mu)*signal_i*(X(:,counter)-X_mu)))/(1+exp(-transpose(X(:,counter)-X_mu)*signal_i*(X(:,counter)-X_mu)))-2)...
        *(0.1*Handle_sign*(-X(2,counter)+Poly(1)*X(1,counter)+Poly(2))+exp(-10000*transpose(X_L-X(:,counter))*Q_2));
    
    f_x=SE(DX(:,counter),X(:,counter),A_1,A_2,X_target);
    
    [M,~,CONTACT]=Modulation(Gamma,f_x,DX(:,counter),X(:,counter),X_C,F_d,delta_dx,N_X,q2,Q,Qinv,CONTACT);
    
    if (Handle_sign*(-X(2,counter)+Poly(1)*X(1,counter)+Poly(2)) <=0)
        F(:,counter)=(exp(-10000*(Handle_sign*(-X(2,counter)+Poly(1)*X(1,counter)+Poly(2))))-1)*N_X;
        X(:,counter)=(X(:,counter)-X_L)'*(Q_2)*Q_2/(norm(Q_2)^2)+X_L;
    end
    DDX(:,counter+1)= M*f_x+F(:,counter);
    DX(:,counter+1)=DX(:,counter)+DDX(:,counter+1)*Deltat;
    X(:,counter+1)=X(:,counter)+DX(:,counter+1)*Deltat;
    Time(counter+1)=Time(counter)+Deltat;
    if (norm(X(:,counter+1)-X_target)<0.1)
        break
    end
    
%         if ((rem(counter,100)==0))
% %             DX(:,counter+1)
% %             lambda
% %             f_x
% %             M*f_x
%             subplot(5,2,[1,3]);
%             plot(X(1,counter+1),X(2,counter+1),'.','Color',[0 0 0])
%            hold on
%              subplot(5,2,2);
%             plot(Time(counter+1,1),Gamma,'.','Color',[0 0 0])
%             hold on
%             pause(0.0001);
%             subplot(5,2,4);
%             plot(Time(counter+1,1),F(:,counter),'.','Color',[0 0 0])
%             hold on
%             pause(0.0001);
%         end
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

function [M,Lambda,CONTACT] = Modulation(Gamma,f_x,DX,X,X_C,F_d,delta_dx,N_X,q2,Q,Qinv,Contact)
epsilon=0.00000001;
DX_G=N_X'*DX;
Lambda=zeros(2,2);
if Contact==1
    CONTACT=1;
else
    CONTACT=0;
end
if (1<=Gamma)
    Lambda(1,1) = (1-exp(-(1/epsilon)*(Gamma-1)))/(1+exp(-(1/epsilon)*(Gamma-1)));
end
if (((DX_G<delta_dx)&&((0<Gamma)&&(Gamma<1)))&&( Contact==0))
    Lambda(1,1) = 10*(1-Gamma)*(delta_dx-DX_G)/(abs(Gamma)*N_X'*f_x);
end
if (((DX_G<0)&&((delta_dx<=DX_G)))&&((0<Gamma)&&(Gamma<1)))
    Lambda(1,1) =-(1-Gamma)*F_d*exp(-Gamma/epsilon);
end
if ((0<=DX_G)&&((0<Gamma)&&(Gamma<1)))
    Lambda(1,1) =  -(1-Gamma)*(DX_G+exp(-Gamma/epsilon))*F_d/(N_X'*f_x);
end
if ((Gamma<=0))
    Lambda(1,1) =  -F_d/(N_X'*f_x);
end
if (1<=Gamma)
    Lambda(2,2)=Lambda(1,1);
elseif ((0<Gamma)&&(Gamma<1)&&( Contact==0))
    Lambda(2,2)= 10*(1-Gamma)*(-(1/(Gamma+0.001))*(q2'*DX*N_X'*(X-X_C)-N_X'*DX*q2'*(X-X_C)))/(N_X'*(X-X_C)*q2'*f_x);
elseif ((Gamma<=0)&&( Contact==0))
    CONTACT=1;
    Lambda(2,2)=1;
elseif ( Contact==1)
    Lambda(2,2)=1;
end
%     if norm(Lambda)>1000
%         keyboard
%     end
M=Q*Lambda*Qinv;

end
