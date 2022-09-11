TE_seebeck = 162 * 10^-6;
TE_elec_resistivity = 5.4945e-6;
hot_temp = 300.15; % NEED TO CHANGE BELOW TOO
tot_pow = 5000000;
dynamic_visc = 1.73*10^-3;
cold_temp = 279.15; % NEED TO CHANGE BELOW TOO

data_matrix = [];

count = 1;
for pipe_radius = [.001 : .01 : .1, .1 : .25 : 5]
    for pipe_length = .1 : .25 : 5
        for velocity = 0.1 : 0.125 : 2.5
            for TE_thickness_exp = -10 : .35 : -3
                TE_thickness = exp(TE_thickness_exp);
%                 
                TE_thickness = 0.001;
                pipe_length = 1;
                pipe_radius = 1;
                velocity = .1;

                kg_flow_rate = velocity*pi*pipe_radius*pipe_radius*997;
                pressure = 8*dynamic_visc*pipe_length*kg_flow_rate/(pi*pipe_radius^4);
                pump_pow_pipe = pressure*pi*pipe_radius*pipe_radius*velocity;

                r = linspace(0,pipe_radius,2); %101
                x = linspace(0,pipe_length,2); %101
                dR = r(2)-r(1);
                dX = x(2)-x(1);

                m = 1;
                sol = pdepe(m, @pdefun, @icfun, @bcfun, r, x, [], velocity, TE_thickness);
                solFlipped = flipud((sol)');
                
% 
%                 imagesc(x,r,sol');
%                 set(gca, 'YDir', 'normal');
%                 colorbar
%                 ylabel('Radius (m)', 'FontName', 'Arial', 'FontSize', 20)
%                 xlabel('Distance from Pipe Inlet (m)','FontName', 'Arial', 'FontSize', 20)
%                 title('Temperature Distribution within Pipe', 'FontName', 'Arial', 'FontSize', 30,'FontWeight','Normal')

                dElec_resistance = TE_elec_resistivity*TE_thickness/(2*pi*pipe_radius*dX);
                pipe_pow = sum(arrayfun(@(x) powerfun(hot_temp-x, TE_seebeck, dElec_resistance),solFlipped(1,:)));
                pump_pow_fraction = pump_pow_pipe/pipe_pow;
                new_tot_pow = tot_pow/(1-pump_pow_fraction);

                num_pipes = new_tot_pow/pipe_pow;
                tot_material = (pi*TE_thickness*TE_thickness + 2*pi*pipe_radius*TE_thickness)*pipe_length*num_pipes;
                tot_water_rate_kg = kg_flow_rate*num_pipes;

                cold_water_temp_change = 0;
                for i = 1 : size(r,2)-1
                    cold_water_temp_change = cold_water_temp_change + (pi*dR*dR + 2*pi*r(i)*dR)*solFlipped(i,end);
                end
                cold_water_temp_change = cold_water_temp_change/(pi*pipe_radius*pipe_radius) - cold_temp;

                data_matrix(end+1, :) = [pipe_radius, pipe_length, num_pipes, tot_material, tot_water_rate_kg, pump_pow_fraction, velocity, TE_thickness, cold_water_temp_change];
                disp(count)
                count = count + 1;
            end
        end
    end
end
%%
% data_matrix = round(data_matrix, 4);
% data_matrix = data_matrix(data_matrix(:,4)>0, :);
% data_matrix = data_matrix(data_matrix(:,5)>0, :);


%determining costs
wall_thickness = 0.0015;
CuNiAlloy_cost_kg = 10;
outer_radius = data_matrix(:,1) + data_matrix(:,8) + wall_thickness*2;
outer_TE_radius = data_matrix(:,1) + data_matrix(:,8) + wall_thickness;
outer_innerwall_radius = data_matrix(:,1) + wall_thickness;

outer_wall_volume_per_pipe = data_matrix(:,2) .* pi .* (outer_radius.^2 - outer_TE_radius.^2);
inner_wall_volume_per_pipe = data_matrix(:,2) .* pi .* (outer_innerwall_radius.^2 - data_matrix(:,1).^2);
total_wall_volume = (outer_wall_volume_per_pipe + inner_wall_volume_per_pipe) .* data_matrix(:,3);
total_wall_cost = total_wall_volume .* 8490 .* CuNiAlloy_cost_kg;

BiTe_cost_kg = 280;
total_te_cost = data_matrix(:,4) .* 7700 .* BiTe_cost_kg;

data_matrix(:,10) = total_te_cost + total_wall_cost;

% determining efficiency
specific_heat_capacity_water = 4184; % j/(kg*oC)
carnot_eff = (hot_temp-cold_temp)/hot_temp;
total_heat_input = specific_heat_capacity_water .* data_matrix(:,9) .* data_matrix(:,5);

data_matrix(:,11) = tot_pow./(total_heat_input.*carnot_eff);
% data_matrix(:,11) = tot_pow./(total_heat_input);

% data_filtered = data_matrix(data_matrix(:,1)==3.1, :);
% data_filtered = data_filtered(data_filtered(:,7)==0.5, :);
% yyaxis left
% plot(data_filtered(:,2), data_filtered(:,4));
% xlabel('Pipe length')
% ylabel('Total material')
% yyaxis right
% plot(data_filtered(:,2), data_filtered(:,5));
% ylabel('Total water rate kg')
% 
% figure;
% data_filtered = data_matrix(data_matrix(:,2)==0.6, :);
% data_filtered = data_filtered(data_filtered(:,7)==0.5, :);
% yyaxis left
% plot(data_filtered(:,1), data_filtered(:,4));
% ylim([0 inf])
% xlabel('Pipe radius')
% ylabel('Total material')
% yyaxis right
% plot(data_filtered(:,1), data_filtered(:,5));
% ylabel('Total water rate kg')
% 
% scatter3(data_matrix(:,4), data_matrix(:,5), data_matrix(:,2));
% scatter3(d(:,4), d(:,5), d(:,2));
% xlabel('tot material')
% ylabel('tot water rate kg')
% ylim([0 700000000])
% xlim([0 5000])
% zlabel('pipe length')

list_order = "pipe_radius, pipe_length, num_pipes, tot_material, tot_water_rate_kg, pump_pow_fraction, velocity, TE_thickness, cold_water_temp_change";
s = scatter(data_matrix(:, 4), data_matrix(:, 5));
xlabel('total material')
ylabel('total water rate kg')
hold off;

function [pow] = powerfun(dT, seebeck, elec_resistance)
    voltage = seebeck*dT;
    pow = voltage^2/(4*elec_resistance);
end

function [c,f,s] = pdefun(r,x,u,dudr,velocity,TE_thickness)
    specific_heat_capacity_water = 4184; % j/(kg*oC)
    therm_conductivity_water = 0.598; % W/m·K at 20 °C
    c = velocity*specific_heat_capacity_water*1000;
    f = dudr*therm_conductivity_water;
    s = 0;
end

function u0 = icfun(r, velocity,TE_thickness)
    cold_temp = 279.15;
    u0 = cold_temp;
end

function [pL,qL,pR,qR] = bcfun(rL,uL,rR,uR,x,velocity,TE_thickness)
    hot_temp = 300.15;
    therm_conductivity_TE = 1.4;
    therm_conductivity_water = 0.598; % W/m·K at 20 °C
    pL = 0;
    qL = 1;
    pR = -therm_conductivity_TE/TE_thickness*(hot_temp-uR);
    qR = therm_conductivity_water;
end