function createGraph(x, y, x_label, y_label, title_label, marked_x_values, marked_y_values)
    figure;
    hold on;
    for i = 1 : size(x,1)
        scatter(x(i,:), y(i,:));
    end
    xlabel(x_label);
    ylabel(y_label);
    title(title_label);
    
    if exist('marked_x_values','var')
        xline(marked_x_values);
    end
    if exist('marked_y_values','var')
        yline(marked_y_values);
    end
end

