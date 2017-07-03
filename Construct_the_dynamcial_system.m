function [A,Dem_i,check]=Construct_the_dynamcial_system(N_x,Poly,X_target,limits)


close all
X(1,:) = linspace(limits(1,1),limits(1,2),10^5);
X(2,:) = Poly(1)*X+Poly(2);
screensize = get( 0, 'Screensize' );
fig = figure();
set(fig,'Position',screensize)
plot(X(1,:),X(2,:),'DisplayName','The contact surface','LineWidth',4,...
    'LineStyle','--',...
    'Color',[0 0 0]);
hold on
xlabel('X(1)','Interpreter','latex');
ylabel('X(2)','Interpreter','latex');
plot(X_target(1,1),X_target(2,1),'DisplayName','The target','MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor','none',...
    'MarkerSize',30,...
    'Marker','pentagram',...
    'LineWidth',5,...
    'LineStyle','none');
legend1 = legend('show');
set(legend1,'Interpreter','latex','FontSize',20);
[Data,Dem_i]=generate_mouse_data(limits,1,1,'Draw some motions, make sure that it ends up at the target point and it goes through the contact surface !',fig);

d=2;
C=[];

% P = sdpvar(2*d,2*d);
% A = [zeros(d,d)  eye(d,d); sdpvar(d,d,'full') sdpvar(d,d,'full')];
% C=[transpose(A)*P+P*A<= -0.0001*eye(2*d,2*d)];
% C=C+[0.0001*eye(2*d,2*d)<=P];
% Fun=(A*Data(1:2*d,:));
% diff=Fun(d+1:2*d,:)-Data(3*d+1:4*d,:);
% P = sdpvar(d,d);
Omega1=sdpvar(1,1);
A = [Omega1 0;0 Omega1];
C=C+[Omega1<= -0.0001];
% C=C+[0.0001*eye(d,d)<=P];
Fun=(A*Data(1:d,:));
diff=Fun(1:d,:)-Data(d+1:2*d,:);

aux = sdpvar(d,length(diff));
Fun=sum((sum(aux.^2)));
C=C+[aux == diff];
options_solver=sdpsettings('solver','sedumi', ...
                           'verbose', 0);
sol =  optimize(C,Fun,options_solver);
if sol.problem~=0
    disp('The optimization did not work. You need to change the solver or start it over!')
    check=0;
else
    disp('The dynamical system is successfully constructed!')
    check=1;
end
Time=sol.solvertime;
A= value(A);
A = [zeros(d,d)  eye(d,d); A [-2*sqrt(-A(1,1)) 0;0 -2*sqrt(-A(2,2))]];
% A(1+2,1)=-abs(A(1+2,1))*abs(N_x(1));
% A(1+2,2)=(A(1+2,2))*abs(N_x(1));
% A(2+2,1)=(A(2+2,1))*abs(N_x(2));
% A(2+2,2)=-abs(A(2+2,2))*abs(N_x(2));