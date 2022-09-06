clf;
hold on;

mat = data_matrix(data_matrix(:,4)>0, :);
mat = mat(mat(:,9)<=9, :);
mat = mat(mat(:,8)>=0.001, :);
mat = mat(mat(:,5)>0, :);

% all_lengths = unique(mat(:,2)); % change
% sort(all_lengths);
% 
% all_colors = prism(length(all_lengths));
% % c = linspace(1,10,length(all_lengths));
% 
% for count = 1 : 1 : length(all_lengths) % floor(length(all_lengths)/2)
%     len = all_lengths(count); % all_lengths(count*2);
%     filtered_mat = mat(mat(:,2)==len,:); % change
%     s = scatter(filtered_mat(:,5), filtered_mat(:,4),25,all_colors(count,:));%c(count).* ones(length(filtered_mat(:,5)),1));
% end

colormap(jet)
scatter(mat(:,5), mat(:,4), 25, mat(:,9));
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
title("Pipe Length")
xlabel("water flow");
ylabel("material")

hold off;

