%% Setup teh demo
setup_CoDs;

Option.limits= [-5 5 -5 5];
Option.check=0;
Option.Deltat=0.0001;
Option.F_d=6;
Option.delta_dx=-0.5;
Option.Tfinal=100;
Option.animation=0;

%% Constructing the conatct surface
disp('Draw the contact surface')
[N_x,Poly,X_target,Option.check]=Construct_the_surface(Option);
if Option.check==0
      error('Program exit')
end

 %% Constructing the dynamcail system
 disp('Draw some motions, make sure that it ends up at the target point and it goes through the contact surface !')
 [A,X_initial,Option.check]=Construct_the_dynamcial_system(Poly,X_target,X_target,Option);
 if Option.check==0
       error('Program exit')
 end
 
[X_C,X_L]=Select_the_contact_point(Poly,X_target,X_initial,Option);
  
 %% Simulate the unmodulated system
 
[DDX_modulated,DX_modulated,X_modulated,F_modulated,Time_modulated]=  simulate_modulated_system(A,N_x,Poly,X_initial,X_target,X_target,X_C,X_L,Option);
 
plot_the_simualtions(DDX_modulated,DX_modulated,X_modulated,F_modulated,Time_modulated,Poly,X_initial,X_target,X_target,X_C,X_L,N_x,Option);
% % 
% simulate_unmodulated_system(A,X_initial);