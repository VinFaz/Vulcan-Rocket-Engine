%Engine Parameters
thrust = 50; %lbf
OF = 2.2;
Pc = 250; %psi
f_inj_stiffness = .25;
ox_inj_stiffness = 1;
exit_vel = 2210.6; %m/s
Cstar = 1604.9; %m/s
Lstar = 30; %in
Cont_ratio = 9; %Ratio of chamber area to throat area
Exp_ratio = 3.1145;
conv_angle = 45;
div_angle = 15;
rho_fuel = 786; %kg/m^3
rho_ox_stp = 23.247; %kg/m^3
rho_ox_500 = 45.122; %kg/m^3	
cd_fuel = .6;
cd_ox = .6;
ox_orifices = 3;
fuel_orifices = 3;
film_orifices = 6;
film_cooling = 0;
cp_ox_500 = 0.97393;
cv_ox_500 = 0.66671;
gamma_ox_500 = cp_ox_500 / cv_ox_500;

%Units
g = 9.81;
lb_to_kg = 0.453592;
m_to_ft = 3.28084;
psi_to_pa = 6894.76;
pi = 3.1415;
m3s_to_cfm = 2118.88;

%Conversions
Pc = Pc * psi_to_pa;
Lstar = (Lstar / 12) / m_to_ft;
thrust = thrust * lb_to_kg * g;

%Calculations
mdot = thrust / exit_vel;
mdot_F = mdot / (OF + 1);
mdot_O = mdot - mdot_F;
qdot_F = mdot_F / rho_fuel;
qdot_O = mdot_O / rho_ox_stp;
sqdot_O = qdot_O * (Pc / (14.7 * psi_to_pa));

At = (mdot * Cstar) / Pc;
rt = sqrt(At / pi);
Ae = At * Exp_ratio;
re = sqrt(Ae / pi);
Ac = Cont_ratio * At;
rc = sqrt(Ac / pi);
V_c = Lstar * At; 
a = tand(conv_angle);
conv_length = (rc - rt) / a;
conv_vol = ((pi * conv_length) / 3) * (rc^2 + rt^2 + (rc * rt));
straight_vol = V_c - conv_vol;
straight_length = straight_vol / Ac;

mdot_F_thrust = mdot_F * (1 - film_cooling);
mdot_F_film = mdot_F - mdot_F_thrust;
F_thrust_A = mdot_F_thrust / (cd_fuel * sqrt(2 * rho_fuel * (((1 + f_inj_stiffness) * Pc)) - Pc));
F_film_A = mdot_F_film / (cd_fuel * sqrt(2 * rho_fuel * (((1 + f_inj_stiffness) * Pc)) - Pc));
Ox_A = mdot_O / (cd_ox * sqrt(gamma_ox_500 * (rho_ox_500 * (((Pc * (1 + ox_inj_stiffness)) / psi_to_pa) / 500)) * (Pc * (1 + ox_inj_stiffness)) * (2 / (gamma_ox_500 + 1))^((gamma_ox_500 + 1) / (gamma_ox_500 - 1)))); 
F_thrust_orifice_r = sqrt((F_thrust_A / fuel_orifices) / pi);
F_film_orifice_r = sqrt((F_film_A  / film_orifices) / pi);
Ox_orifice_r = sqrt((Ox_A / ox_orifices) / pi);

%Outputs
fprintf("Thrust: %.2f lbf | OF: %.2f | Pc: %.2f psia\n", thrust / lb_to_kg / g, OF, Pc / psi_to_pa);
fprintf("IPA Mass Flow: %.5f kg/s | GOX Mass Flow: %.5f kg/s\n", mdot_F, mdot_O);
fprintf("IPA Volumetric Flow: %.3f CFM| GOX Volumetric Flow: %.3f CFM | GOX Standard Volumetric Flow: %.3f SCFM\n", qdot_F * m3s_to_cfm, qdot_O * m3s_to_cfm, sqdot_O * m3s_to_cfm);
fprintf("\nChamber Dimensions_____\n");
fprintf("Chamber Radius: %.3f in | Throat Radius: %.3f in | Exit Radius: %.3f in\n", rc * m_to_ft * 12, rt * m_to_ft * 12, re * m_to_ft * 12);
fprintf("Straight Chamber Length: %.2f in | L*: %.2f in\n", straight_length * m_to_ft * 12, 12 * Lstar * m_to_ft);

fprintf("\nOrifice Sizing_____\n");
fprintf("Main Fuel Orifice Radius: %.3f thou | Film Cooling Orifice Radius: %.3f thou\n", F_thrust_orifice_r * m_to_ft * 12000,  F_film_orifice_r * m_to_ft * 12000);
fprintf("GOX Orifice Radius: %.3f thou\n", Ox_orifice_r * m_to_ft * 12000);


