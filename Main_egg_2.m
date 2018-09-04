%MAIN Summary of this function goes here
%   This function is for reachign a circle shaped surface.
close all
setup_CoDs;

Option.limits= [-5 5 -5 5];
Option.check=0;
Option.Deltat=0.001;
Option.delta_dx=-0.5;
Option.Tfinal=1000;
Option.rho=1.0;
Option.Onsurface=0;
Option.egg2=1;
disp('Draw the contact surface')

[Center,Radiusy,Target]=Construct_the_egg(Option);
[A,X_initial]=Construct_the_dynamcial_system_for_egg(Center,Radiusy,Option);
[~,DX_modulated,X_modulated,DX_G,~]= simulate_modulated_system_egg(Center,Radiusy,Target,A,Option);
plot_the_simualtions_egg(X_modulated,Center,Radiusy,Target,Option);
plot_animation_egg(X_modulated,Center,Radiusy,Target,Option);

%%
for i=1:size(DX_G,2)
    DX_G{i}=DX_G{i}(DX_G{i}~=0);
    Dcontact(i)=DX_G{i}(end);
end
mean(Dcontact)
std(Dcontact)
min(Dcontact)