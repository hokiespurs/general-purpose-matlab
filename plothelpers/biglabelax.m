function [htxt,h]= biglabelax(ax,labelstr,dx,varargin)

drawnow;pause(0.05);%getting errors because axes werent drawn yet

pos = maxpos(ax);
xpos = pos(1)-dx;
ypos = pos(2) + (pos(4))/2;
[htxt,h]= biglabel(labelstr,xpos,ypos,varargin{:});

end

