%====================Parameters====================
%total mass of the vehicle, ask your mechanics
tot_m = 0.5; %in kg (assumption)
%mass of each motors, ask your mechanics
%unused in this program
mass1 = 0.1; %in kg
mass2 = 0.1; %in kg
mass3 = 0.1; %in kg
mass4 = 0.1; %in kg
%Radius of the prop, ask your mechanics
%unused in this program
radius1 = 0.1; %in meter
radius2 = 0.1; %in meter
radius3 = 0.1; %in meter
radius4 = 0.1; %in meter
%Length of the arm, ask your mechanics
frame_r = 0.25; %in meter (assumption)
%Center of mass, ask your mechanics
x_com = 0.5; %center of mass in meter
y_com = 0.5; %center of mass in meter
%Thrust force for each propellers (assumptions), ask your mechanics
f1 = 1.0;
f2 = 1.0;
f3 = 1.0;
f4 = 1.0;
%Moment of inertia along the x, y, and z-axis, ask your mechanics
%assumption
I_x = 0.0196; %in kgm^2
I_y = 0.0196; %in kgm^2
I_z = 0.0264; %in kgm^2
%moment of each motor, ask your mechanics (assumption)
m1 = 0.5; %in Nm
m2 = 0.5; %in Nm
m3 = 0.5; %in Nm
m4 = 0.5; %in Nm
%acceleration due to gravity (fixed)
g = -9.81 %in ms^-2

%====================F to M scaling factor====================
total_moment =  m1+m2+m3+m4;
total_force = f1+f2+f3+f4;
fm_scaling_factor = total_moment/((total_force)*(sqrt(x_com*x_com + y_com*y_com)))
%source: OpenAI

%Define state matrices
A = [0 0 0 1 0 0 0 0 0 0 0 0;
     0 0 0 0 1 0 0 0 0 0 0 0;
     0 0 0 0 0 1 0 0 0 0 0 0;
     0 0 0 0 0 0 0 -g 0 0 0 0;
     0 0 0 0 0 0 g 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 0 0 0 1 0;
     0 0 0 0 0 0 0 0 0 0 0 1;
     0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0];
 
 B = [0 0 0 0;
      0 0 0 0;
      0 0 0 0;
      0 0 0 0;
      0 0 0 0;
      (-1/tot_m) (-1/tot_m) (-1/tot_m) (-1/tot_m);
      0 0 0 0;
      0 0 0 0;
      0 0 0 0;
      0 (frame_r/I_x) 0 (-frame_r/I_x);
      (frame_r/I_y) 0 (-frame_r/I_y) 0;
      (-fm_scaling_factor/I_z) (fm_scaling_factor/I_z) (-fm_scaling_factor/I_z) (fm_scaling_factor/I_z)];
  
  C = [1 0 0 0 0 0 0 0 0 0 0 0;
       0 1 0 0 0 0 0 0 0 0 0 0;
       0 0 1 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 1 0 0 0 0 0;
       0 0 0 0 0 0 0 1 0 0 0 0;
       0 0 0 0 0 0 0 0 1 0 0 0];
   
  D = 0;
   
  sys = ss(A,B,C,D);
  B_rank = rank(B)
  A_rank = rank(A)
  P = [-4+3i;-4-3i;-6;-6.5;-7;-7.5;-7.8;-8;-8.2;-8.4;-8.6;-9];
  P_rank = rank(P)
  K = place(A,B,P) %put this thing to khageswara
  
  Acl = A - B*K
  Ecl = eig(Acl)
  
  syscl = ss(Acl,B,C,D)
  step(syscl)
  
  %Sources:
  %https://youtu.be/hpeKrMG-WP
  %https://youtu.be/TKBm1GzxUO8

