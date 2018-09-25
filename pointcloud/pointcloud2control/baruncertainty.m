function baruncertainty(y,dy,cmap,legendlabels,grouplabels)
GAPPERCENT = 20;
%%
nGroups = size(y,1);
nBars = size(y,2);

%% arrange layout
% barWidth = 1/(2+nBars)/(1+GAPPERCENT/100);
barWidth = 1/(2+nBars+(-1+nBars)*GAPPERCENT/100);

xposStart = barWidth:barWidth*(1+GAPPERCENT/100):barWidth + nGroups * barWidth*(1+GAPPERCENT/100);
xposEnd = xposStart + barWidth;



%% Handle Legend
for i=1:nBars
    patch([0.5 0.5 0.5 0.5],[0 0 0 0],cmap(i,:),'faceAlpha',0);
end
hold on
for i = 1:nBars
    for j = 1:nGroups
      xoffset = j-0.5;
      yval = y(j,i);
      dyval = dy(j,i);
      
      % YVAL RECT
      rectx = xoffset + [xposStart(i) xposStart(i) xposEnd(i) xposEnd(i)];
      recty = [0 yval yval 0];
      rectcolor = cmap(i,:);
      
      patch(rectx,recty,rectcolor,'faceAlpha',1,'edgeColor',rectcolor);
      
%       % DY RECT
%       rectdy = [yval-dyval yval+dyval yval+dyval yval-dyval];
%       rectcolor = cmap(i,:);
%       patch(rectx,rectdy,rectcolor,'faceAlpha',0.7,'edgeColor',rectcolor);

      % errorbar lines
      errorbar(xoffset + xposStart(i)+barWidth/2,yval,dyval,'k.')
%       
%       plot(rectx([1 4]),[yval yval],'k-','linewidth',1)
%       plot(rectx([1 4]),[yval yval]-dyval,'k-','linewidth',.5)
%       plot(rectx([1 4]),[yval yval]+dyval,'k-','linewidth',.5)
%       plot(xoffset+[xposStart(i)+barWidth/2 xposStart(i)+barWidth/2],...
%            [yval-dyval yval+dyval],'k--')
   end
end
plot([0.5 nGroups+0.5],[0 0],'k')
grid on
xticks(1:nGroups);
end