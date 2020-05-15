function figpos = goodfigsize(FIG)

% get the perfect figure size for large paneled figures (SEML,
% plot_campbell, etc...)

scrsiz = get(0,'screensize');
xsiz = 1400;
ysiz = 1000;
xpos = (scrsiz(3)-xsiz)/2;
ypos = scrsiz(4)- ysiz - 80;
figpos = [xpos ypos xsiz ysiz];