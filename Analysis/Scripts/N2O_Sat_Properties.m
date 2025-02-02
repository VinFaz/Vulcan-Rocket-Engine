function [output_val] = N2O_Sat_Properties(phase, input_type, input_val, output_type)
%NOX_SAT_LIQUID Summary of this function goes here
%   Detailed explanation goes here

if(phase == "liquid")
    data = readmatrix("Nitrous_Sat_Lqd.xlsx");
else
    data = readmatrix("Nitrous_Sat_Gas.xlsx");
end

property_cols = ["temperature", "pressure", "density", "specific volume", "internal energy", "enthalpy", "entropy", "cp", "cv"];
input_col = find(property_cols == input_type);
output_col = find(property_cols == output_type);


exact_row_index = find(data(1:end, input_col) == input_val);
if(exact_row_index ~= 0)
    output_val = data(exact_row_index, output_col);
    %fprintf("%.3f\n", output_val);
    

else
    %fprintf("Interpolating...\n");
    
    for row = 2:1:numel(data(1:end, input_col))
        if(data(row-1, input_col) < input_val && data(row, input_col) > input_val)
            lower_bound_row = row-1;
            upper_bound_row = row;
        end
    end

    lower_bound_input_val = data(lower_bound_row, input_col);
    upper_bound_input_val = data(upper_bound_row, input_col);
    %fprintf("The value %.2f is in between %.2f and %.2f", input_val, lower_bound_input_val, upper_bound_input_val);

    diff = (input_val - lower_bound_input_val);
    lower_bound_output_val = data(lower_bound_row, output_col);
    upper_bound_output_val = data(upper_bound_row, output_col);
    slope = (upper_bound_output_val - lower_bound_output_val) / (upper_bound_input_val - lower_bound_input_val);

    output_val = lower_bound_output_val + (slope * diff);

end

