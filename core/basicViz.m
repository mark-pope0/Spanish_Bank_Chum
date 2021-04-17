%% Spanish returns
clear
close all
colours = parula(8);
load returnsSpanish
figure(1)
    clf
H = bar(categorical(tReturnsSpanish),returnsSpanish);
H.FaceColor = colours(3,:);
title('chum salmon returns to Spanish Bank Creek, 2003 to present')
ylabel('returns (individuals)')
set(gca,'YGrid',true,'GridLineStyle',':')
    clearvars -except colours

%% Spanish releases
clear
close all
colours = parula(8);
load releasesSpanish
figure(1)
    clf
H = bar(categorical(tReleasesSpanish),releasesSpanish/1000);
H.FaceColor = colours(5,:);
title(["chum fry releases into Spanish Bank Creek,";
    "brood year 1999 to present"])
ylabel('releases (thousands)')
xlabel('brood year (release year - 1)')
set(gca,'YGrid',true,'GridLineStyle',':')
    clearvars -except colours
    
%% Spanish returns & releases correlation
clear
close all
colours = parula(8);
load dataCompiled releasesSpanish releasesSpanishWeight returnsSpanish
figure(1)
    clf
subplot(1,2,1)
scatterCC(releasesSpanish/1000,returnsSpanish,colours(5,:), 70,60)
title('Spanish returns & releases (+ 4 years)')
xlabel('releases (thousands)')
ylabel('returns (individuals)')        

subplot(1,2,2)
scatterCC(releasesSpanishWeight,returnsSpanish,colours(3,:), .85,60)
title('Spanish returns & release weights (+ 4 years)')
xlabel('mean weight at release (g)')
ylabel('returns (individuals)')
    legend('off')

%% Spanish returns & bug counts
clear
close all
colours = parula(8);
load dataCompiled releasesSpanish releasesSpanishWeight ...
    returnsSpanish dataBugs fieldsBugs t
figure(1)
    clf
subplot(1,3,1)
scatterCC(dataBugs((5:end),2),returnsSpanish((5:end)),colours(4,:), 1900,8)
title(["Spanish returns & bug count density"; "2006 - 2019"])
xlabel('bug density (ind./m^2)')
ylabel('returns (individuals)')
subplot(1,3,2)
scatterCC(dataBugs(:,3),returnsSpanish,colours(5,:), 25.5,55)
title(["Spanish returns & bug count pollution tolerant index";
    "2003 - 2019"])
xlabel('pollution tolerant index')
ylabel('returns (individuals)') 
subplot(1,3,3)
scatterCC(dataBugs((5:end),4),returnsSpanish((5:end)),colours(6,:), 9.6,8)
title(["Spanish returns & bug count EPT index";
    "2006 - 2019"])
xlabel('EPT index')
ylabel('returns (individuals)') 

%% Spanish water vs air temps
clear
close all
colours = parula(8);
load SpanishWaterTemps
load weather 
c = year(tWeather) == 2006;
tWeather = tWeather(c);
tempMax  = tempMax(c);
tempMean = tempMean(c);
tempMin  = tempMin(c);
    clear c
c = month(tWeather) >= 10 & month(tWeather) <= 11;

figure(1)
    clf
subplot(1,3,1)
scatterCC(tempMin,waterTempMin,colours(1,:), 15,8)
hold on
scatter(tempMin(c),waterTempMin(c),[],colours(5,:),'x')
tempTempLines
title(["";"daily minimum"])
xlabel('air temperature (°C)')
ylabel('water temperature (°C)')

subplot(1,3,2)
scatterCC(tempMean,waterTempMean,colours(1,:), 15,8)
hold on
scatter(tempMean(c),waterTempMean(c),[],colours(5,:),'x')
tempTempLines
title(["water & air temperatures in 2006; October & November highlighted"; "daily mean"])
xlabel('air temperature (°C)')
ylabel('water temperature (°C)')

subplot(1,3,3)
scatterCC(tempMax,waterTempMax,colours(1,:), 15,8)
hold on
scatter(tempMax(c),waterTempMax(c),[],colours(5,:),'x')
tempTempLines
title(["";"daily maximum"])
xlabel('air temperature (°C)')
ylabel('water temperature (°C)')

%% Indian-Spanish & Kanaka-Spanish correlations
clear
close all
colours = parula(8);
load dataCompiled returnsSpanish returnsIndian returnsKanaka4
figure(1)
    clf
subplot(1,2,1)
scatterCC(returnsIndian/1000,returnsSpanish,colours(5,:), 70,60)
title('Spanish & Indian chum returns')
xlabel('Indian returns (thousands)')
ylabel('Spanish returns (individuals)')        

subplot(1,2,2)
scatterCC(returnsKanaka4/1000,returnsSpanish,colours(3,:), .85,60)
title('Spanish & Kanaka (+4 yrs) returns')
xlabel('Kanaka returns, four years offset (thousands)')
ylabel('Spanish returns (individuals)')
    legend('off')







%% mini-functions
function tempTempLines
line([-10 25],[-10 25],'color',[.4 .4 .4]) % 1:1
line([-10 25],[11 11],'color',[.4 .4 .4],'linestyle',':') % ideal for adults
line([-10 25],[16 16],'color',[.4 .4 .4],'linestyle',':') % spawning max
axis([-10,25, -10,25])
end

