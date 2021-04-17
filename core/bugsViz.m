clear
load bugsScraped.mat
colours = parula(24);

%% disaggregated data
figure(1)
    clf
for ip = 1:6
    subplot(2,3,ip)
    H = bar(tBugs,dataBugs(ip,:));
    H.FaceColor = colours(4,:);
    xtickangle(90)
    xticklabels(year(tBugs));
    title(fieldsBugs(ip))
end

%% averaged ordinal data (statistically invalid)
dataBugsOrd = nan(size(dataBugs));
for it = 1:size(dataBugs,2)
    if dataBugs(3,it) < 11
        c = 1;
    elseif dataBugs(3,it) < 17
        c = 2;
    elseif dataBugs(3,it) <= 22
        c = 3;
    else
        c = 4;
    end
    dataBugsOrd(3,it) = c;
    
    if dataBugs(4,it) <= 1
        c = 1;
    elseif dataBugs(4,it) <= 5
        c = 2;
    elseif dataBugs(4,it) <= 8
        c = 3;
    else
        c = 4;
    end
    dataBugsOrd(4,it) = c;
    
    if dataBugs(5,it) <= .25
        c = 1;
    elseif dataBugs(5,it) <= .5
        c = 2;
    elseif dataBugs(5,it) <= .75
        c = 3;
    else
        c = 4;
    end
    dataBugsOrd(5,it) = c;
    
    if dataBugs(5,it) > .8
        c = 1;
    elseif dataBugs(5,it) > .6
        c = 2;
    elseif dataBugs(5,it) > .4
        c = 3;
    else
        c = 4;
    end
    dataBugsOrd(6,it) = c;
        clear c
end
dataBugsOrd(1:2,:) = [];

figure(2)
    clf
bar(tBugs,mean(dataBugsOrd),'facecolor',colours(1,:))
title("PSkF site assessment rating for Spanish Bank Creek")
ylabel('mean of ordinal indices')
ylim([0,4])
set(gca,'XTickLabelRotation',45, 'ygrid','on', ...
    'GridLineStyle',':', 'GridAlpha',.25)
exportgraphics(gcf,'figsPrelim/figBugCountMean.png', 'Resolution',500)







