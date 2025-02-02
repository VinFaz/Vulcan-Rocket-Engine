Pc = 250; %psi
f_injector_stiffness = .3;
ox_injector_stiffness = 1;

rho_fuel = 786; %kg/m^3
mdot_fuel = .05032; %kg/s
rho_ox_250 = 23.247; %kg/m^3	
mdot_ox = .05032; %kg/s

fuel_line_dia = .25; %in
ox_line_dia = 3/8; %in
tube_wall_thickness = 35; %thou

%Conversions
psi_to_Pa = 6895;
cv_to_cda = 58888; %cv / cdA
in_to_m = 0.0254; %m  / in
pi = 3.1415;
ft_to_m = 0.3048; %m / ft

%Calculations
Pc = Pc * psi_to_Pa;
P_inj_ox = (Pc * (1 + ox_injector_stiffness));
P_inj_f = (Pc * (1 + f_injector_stiffness));
rho_inj_ox = rho_ox_250 * (P_inj_ox / (250 * psi_to_Pa));
gamma_ox = .94671 / 0.66281;
run_solenoid_cv = .2;
gox_reg_cv = .8;
run_solenoid_cda = run_solenoid_cv / cv_to_cda;
gox_reg_cda = gox_reg_cv / cv_to_cda;

%Fuel
P_run_fuel = P_inj_f + (((mdot_fuel / run_solenoid_cda)^2) / (2 * rho_fuel)); %inlet pressure of run valve
fuel_line_A = pi * (in_to_m * ((fuel_line_dia / 2) - (tube_wall_thickness / 1000)))^2;
fuel_line_vel = mdot_fuel / (rho_fuel * fuel_line_A);

%GOX
P_run_ox = Compressible_flow_P1(mdot_ox, rho_inj_ox, 5, P_inj_ox, gamma_ox);
reg_min_inlet_P = (mdot_ox / gox_reg_cda)^2 / ((rho_inj_ox * gamma_ox * (2 / (gamma_ox + 1))^((gamma_ox + 1) / (gamma_ox - 1))));
if(reg_min_inlet_P < P_run_ox)
    ox_reg_P = P_run_ox;
else
    ox_reg_P = reg_min_inlet_P;
end
ox_line_A = pi * (in_to_m * ((ox_line_dia / 2) - (tube_wall_thickness / 1000)))^2;
ox_line_vel = mdot_ox / (rho_ox_250 * (ox_reg_P / (250 * psi_to_Pa)) * ox_line_A);

%Outputs

fprintf("IPA Reg Set Pressure: %.3f psi | GOX Reg Set Pressure: %.3f psi\n", P_run_fuel / psi_to_Pa, ox_reg_P / psi_to_Pa);
fprintf("Fuel Line Velocity: %.3f ft/s | GOX Line Velocity: %.3f ft/s\n", fuel_line_vel / ft_to_m, ox_line_vel / ft_to_m);