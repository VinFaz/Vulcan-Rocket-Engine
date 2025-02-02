%Simulation Setup
m = 10; %lb (nitrous weight)
bottle_V = 0.0057; %m^3
mdot = .1; %kg/s
burn_time = 3; %seconds
start_temp = 300; %Kelvins

t_step = .05; %seconds
time = t_step:t_step:burn_time;
temps = zeros(burn_time / t_step, 1);
pressures = zeros(burn_time / t_step, 1);
quality = zeros(burn_time / t_step, 1);


%Units and Conversions
kg_per_lb = 1 /  2.205;
in_per_m = 39.3701;

m = m * kg_per_lb;

%Calculations (assumes adiabatic tank)
temps(1) = start_temp;
pressures(1) = N2O_Sat_Properties("liquid", "temperature", start_temp, "pressure");
avg_density = m / bottle_V;
lqd_density = N2O_Sat_Properties("liquid", "temperature", start_temp, "density");
gas_density = N2O_Sat_Properties("gas", "temperature", start_temp, "density");
quality(1) = (avg_density - lqd_density) / (gas_density - lqd_density);
m_f = m * (1-quality(1));
m_g = m * (quality(1));
 
for step_num = 2:1:burn_time / t_step
    dm = mdot * t_step;
    m_f = m - dm;
    m = m_g + m_f;

    enthalpy_out = dm * N2O_Sat_Properties("liquid", "temperature", temps(step_num-1), "enthalpy");
    %fprintf("Enthalpy Out: %.3f ", enthalpy_out);
    U_f = (m_f * N2O_Sat_Properties("liquid", "temperature", temps(step_num-1), "internal energy")) - enthalpy_out;
    %fprintf("Specific Int. Energy: %.3f\n", U_f / m_f);
    temps(step_num) = N2O_Sat_Properties("liquid", "internal energy", U_f / m_f, "temperature"); %assume liquid temp = bulk temp
    pressures(step_num) = N2O_Sat_Properties("liquid", "temperature", temps(step_num), "pressure");
    avg_density = m / bottle_V;
    lqd_density = N2O_Sat_Properties("liquid", "temperature", start_temp, "density");
    gas_density = N2O_Sat_Properties("gas", "temperature", start_temp, "density");
    quality(step_num) = (avg_density - lqd_density) / (gas_density - lqd_density);
    m_f = m * (1-quality(step_num));
    m_g = m * (quality(step_num));

end

figure();

subplot(1, 2, 1);
plot(time, temps)
xlabel("Time [s]");
ylabel("Temperature [K]");
grid()

subplot(1, 2, 2);
plot(time, pressures, "red");
xlabel("Time [s]")
ylabel("Pressure [psia]");
grid();

sgtitle("Nitrous Bottle Properties vs. Time");

fprintf("Starting Pressure: %.2f psia | End Pressure: %.2f psia\n", pressures(1), pressures(end));
fprintf("Starting Temperature: %.2fK | End Temperature: %.2fK\n", temps(1), temps(end));