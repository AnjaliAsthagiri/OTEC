%theoretical max efficiency for TEG

%establishing constants
TE_seebeck = 162 * 10^-6;
TE_elec_conductivity = 1/(5.4945e-6);
TE_therm_conductivity = 1.4;
hot_temp = 300.15;
cold_temp = 279.15;
temp_avg = (hot_temp+cold_temp)/2;

%figure of merit
zT_figure_of_merit = ((((TE_seebeck)^2)*TE_elec_conductivity)/TE_therm_conductivity)*temp_avg;

%max efficiency
TEG_max_efficiency = ((hot_temp-cold_temp)/(hot_temp))*((sqrt(1+zT_figure_of_merit)-1)/(sqrt(1+zT_figure_of_merit)+(cold_temp/hot_temp)))






