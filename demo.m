%% Setup paths
setup_cods;



%% Constructing the conatct surface
limits = [-5 5 -5 5];
disp('Draw the contact surface')
[N_x,Poly,X_target,check]=Construct_the_surface(limits);
if check==0
      error('Program exit')
end

 %% Constructing the dynamcail system
 disp('Draw some motions, make sure that it ends up at the target point and it goes through the contact surface !')
 [A,X_initial,check]=Construct_the_dynamcial_system(N_x,Poly,X_target,limits);
 if check==0
       error('Program exit')
 end
 
[X_C,X_L]=Select_the_contact_point(limits,Poly,X_target,X_initial);
  
 %% Simulate the unmodulated system
 
[DDX_modulated,DX_modulated,X_modulated,F_modulated,Time_modulated]=  simulate_modulated_system(A,N_x,Poly,X_initial,X_target,X_C,X_L);
 
plot_the_simualtions(DDX_modulated,DX_modulated,X_modulated,F_modulated,Time_modulated,Poly,X_initial,X_target,X_C,X_L,N_x,limits);
% % 
% simulate_unmodulated_system(A,X_initial);