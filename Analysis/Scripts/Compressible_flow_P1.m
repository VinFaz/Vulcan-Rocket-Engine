function [P1] = Compressible_flow_P1(mdot, rho, Cv, P2, gamma)
%Inputs in SI Units

max_error = .0001; %kg/s
adj_coefficient = 1000;

%Estimate P1 from known mdot
CdA = Cv / 58888;
P1 = P2;
error = mdot;

while abs(error) > max_error
    calc_mdot = CdA * sqrt(gamma * rho * P1 * (1 / (gamma - 1) * ((P2 / P1)^(2 / gamma) - (P2 / P1)^((1 + gamma) / gamma))));
    error = mdot - calc_mdot;
    P1 = P1 + (error * adj_coefficient);
end

%fprintf("Calculated mdot: %.3f kg/s | Target mdot: %.3f kg/s\n", calc_mdot, mdot)
%fprintf("Downstream Pressure: %.3f psi | Upstream Pressure: %.3f psi", P2 / 6895, P1 / 6895);