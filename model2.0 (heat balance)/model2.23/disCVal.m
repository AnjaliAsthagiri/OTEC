function disCVal (fig, C)
    % Plots graph and sets up a custom data tip update function
    % fig = figure('DeleteFcn','doc datacursormode');
    % [X,Y,Z] = peaks(100) ;
    % C = Z ;
    % surf(X,Y,Z,C)
    shading interp 
    dcm_obj = datacursormode(fig);
    set(dcm_obj,'UpdateFcn',{@myupdatefcn,C})
end
function txt = myupdatefcn(~,event_obj,C)
    % Customizes text of data tips
    pos = get(event_obj,'Position');
    I = get(event_obj, 'DataIndex');
    txt = {['X: ',num2str(pos(1))],...
    ['Y: ',num2str(pos(2))],...
    ['Z: ',num2str(pos(3))],...
    ['T: ',num2str(C(I))]};
end

