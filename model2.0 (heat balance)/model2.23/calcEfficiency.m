function s = calcEfficiency(s)
    specific_heat_capacity_water = 4184; % j/(kg*oC)
    carnot_eff = (hot_temp-cold_temp)/hot_temp;
    total_heat_input = specific_heat_capacity_water .* data_matrix(:,9) .* data_matrix(:,5);
    efficiency = tot_pow./(total_heat_input.*carnot_eff);
end
