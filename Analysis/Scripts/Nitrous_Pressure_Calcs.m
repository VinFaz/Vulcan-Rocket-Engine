%Inputs
mdot = .15; %kg/s
T_bottle = 300; %Kelvin
bottle_valve_Cv = 1.013;
run_valve_Cv = 5;

%Conversions
Cv_to_CdA = 1 / 58888;
psi_to_Pa = 6894.7;

%Calculations
P_bottle = N2O_Sat_Properties("liquid", "temperature", T_bottle, "pressure")
rho_out_bottle = N2O_Sat_Properties("liquid", "temperature", T_bottle, "density")
entropy_out_bottle = N2O_Sat_Properties("liquid", "temperature", T_bottle, "entropy");
bottle_valve_CdA = bottle_valve_Cv * Cv_to_CdA;    
run_valve_CdA = run_valve_Cv * Cv_to_CdA;

P_out_iso = ((2 * rho_out_bottle * (P_bottle * psi_to_Pa)) - (mdot / bottle_valve_CdA)^2) / (2 * rho_out_bottle);
P_out_iso = P_out_iso / psi_to_Pa %convert back to Psi

T_out_iso = N2O_Sat_Properties("liquid", "pressure", P_out_iso, "temperature");
entropy_L_out_iso = N2O_Sat_Properties("liquid", "temperature", T_out_iso, "entropy");
entropy_G_out_iso = N2O_Sat_Properties("gas", "temperature", T_out_iso, "entropy");
quality_out_iso = (entropy_out_bottle - entropy_L_out_iso) / (entropy_G_out_iso - entropy_L_out_iso)

rho_L_out_iso = N2O_Sat_Properties("liquid", "temperature", T_out_iso, "density");
rho_G_out_iso = N2O_Sat_Properties("gas", "temperature", T_out_iso, "density");
rho_out_iso = (quality_out_iso * rho_G_out_iso) + (rho_L_out_iso * (1 - quality_out_iso))
