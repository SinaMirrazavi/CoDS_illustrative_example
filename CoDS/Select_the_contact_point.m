function [X_C,X_leave]=Select_the_contact_point(Poly,X_target,X_initial,option)

 limits=option.limits;
% close all
% pause(0.5)
X(1,:) = linspace(limits(1,1),limits(1,2),100);
X(2,:) = Poly(1)*X+Poly(2);
disp('Specify the target position.')
h3=createfigure_with_wall(X(1,:),X(2,:),'Specify the contact position by adding one data point on the contact surface.');
hold on
h2=plot(X_target(1,1),X_target(2,1),'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor','none',...
    'MarkerSize',30,...
    'Marker','pentagram',...
    'LineWidth',5,...
    'LineStyle','none');

h1=plot(X_initial(1,:),X_initial(2,:),...
    'MarkerFaceColor',[0.466666668653488 0.674509823322296 0.18823529779911],...
    'MarkerEdgeColor','none',...
    'MarkerSize',30,...
    'Marker','hexagram',...
    'LineWidth',5,...
    'LineStyle','none');
legend1 = legend('off');
legend2=legend([h1(1) h2 h3],'The initial positions','The target','The contact surface');
set(legend2,'Interpreter','latex','FontSize',20);

disp('Specify the contact position.');
X_contact= ginput(1)';

[~,Distance_i]=min(sum((repmat(X_contact(:,1),1,size(X,2))-X).*...
    (repmat(X_contact(:,1),1,size(X,2))-X),1));
X_C=X(:,Distance_i);


% close all
disp('Specify the target position.');
h3=createfigure_with_wall(X(1,:),X(2,:),'Specify the position where the motion leaves the surface by adding one data point on the contact surface.');
hold on
h2=plot(X_target(1,1),X_target(2,1),'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor','none',...
    'MarkerSize',30,...
    'Marker','pentagram',...
    'LineWidth',5,...
    'LineStyle','none');

h1=plot(X_initial(1,:),X_initial(2,:),...
    'MarkerFaceColor',[0.466666668653488 0.674509823322296 0.18823529779911],...
    'MarkerEdgeColor','none',...
    'MarkerSize',30,...
    'Marker','hexagram',...
    'LineWidth',5,...
    'LineStyle','none');
h4=plot(X_C(1,1),X_C(2,1),...
    'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
    'MarkerSize',30,...
    'Marker','^',...
    'LineStyle','none');
legend1 = legend('off');
legend2=legend([h1(1) h2 h3 h4],'The initial positions','The target','The contact surface', 'Desired contact location');
set(legend2,'Interpreter','latex','FontSize',20);

disp('Specify the position where the motion leaves the surface.');
X_leave= ginput(1)';

[~,Distance_i]=min(sum((repmat(X_leave(:,1),1,size(X,2))-X).*...
    (repmat(X_leave(:,1),1,size(X,2))-X),1));
X_leave=X(:,Distance_i);

[~,Distance_i]=min(sum((repmat(X_target(:,1),1,size(X,2))-X).*...
    (repmat(X_target(:,1),1,size(X,2))-X),1));
X_Target_projections=X(:,Distance_i);
Q_2=(X(:,1)-X(:,end))/norm(X(:,1)-X(:,end));

% if (abs(Q_2'*(X_C-X_Target_projections))<abs(Q_2'*(X_C-X_leave)))
%     disp('The leaving position can not be further than the projection of the target on the surface.')
%     X_leave=X_Target_projections+0.2*(X_C-X_Target_projections);
% end

h5=plot(X_leave(1,1),X_leave(2,1),...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',30,...
    'Marker','v',...
    'LineStyle','none');
legend('off');
legend2=legend([h1(1) h2 h3 h4 h5],'The initial positions','The target','The contact surface', 'Desired contact location', 'Leaving point');
set(legend2,'Interpreter','latex','FontSize',20);
% pause(1)
% close all