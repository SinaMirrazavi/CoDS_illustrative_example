function plot_the_simualtions(X,Poly,X_initial,X_target,X_C,X_L,Limits)
close all;
screensize = get( 0, 'Screensize' );
fig = figure();
axes1 = axes('Parent',fig);
set(fig,'Position',screensize)
plot_Wall_counters(axes1,Poly,X_target,X_C,X_L,Limits)
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
X_wall(1,:) = linspace(Limits(1,1),Limits(1,2),10^5);
X_wall(2,:) = Poly(1)*X_wall+Poly(2);
h3=plot(X_wall(1,:),X_wall(2,:),'LineWidth',4,...
    'LineStyle','--',...
    'Color',[0 0 0]);
hold on
h5=plot(X_L(1,1),X_L(2,1),...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',30,...
    'Marker','v',...
    'LineStyle','none');
h4=plot(X_C(1,1),X_C(2,1),...
    'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
    'MarkerSize',30,...
    'Marker','^',...
    'LineStyle','none');
legend2=legend([h1(1) h2 h3 h4 h5],'The initial positions','The target','The contact surface', 'Desired contact location', 'Leaving point');
set(legend2,'Orientation','horizontal','Location','northwest');
SIZE=size(X{1},2);
for i=1:size(X,2)
    H_animated{i}=animatedline('Color','b','LineWidth',3);
    if size(X{i},2)<SIZE
        SIZE=size(X{i},2);
    end
end
counter=1;
while counter<SIZE
    for i=1:size(X,2)
    addpoints(H_animated{i},X{i}(1,counter),X{i}(2,counter))
        drawnow
    end
    counter=int64(counter+size(X{i},2)/500);
end