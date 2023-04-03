clf;
hold on;

mat = data_matrix(data_matrix(:,4)>0, :);
mat = mat(mat(:,9)<=9, :);
mat = mat(mat(:,8)>=0.0005, :);
mat = mat(mat(:,5)>0, :);

colormap(jet)
scatter(mat(:,5), mat(:,4), 25, mat(:,2));
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
title("Pipe length")
xlabel("Water Flow Required");
ylabel("TE Material Required")
set(gcf,'color','w');
colorbar