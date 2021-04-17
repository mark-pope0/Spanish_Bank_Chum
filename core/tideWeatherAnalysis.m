clear
load tides.mat
load weather.mat
% remember, tide times are in UTC & precip times are in PT
% if they are graphed together, whichever is graphed first becomes the axis
% and the other is automatically converted
heightBench = 3.871 + .305; % Dick estimated "bench" height at 3.871m,
                 % but Spanish tide charts are systemically 30.5cm too low

%% citations
% weather data:
    % https://climate.weather.gc.ca/historical_data/search_historic_data_stations_e.html?searchType=stnProx&timeframe=1&txtRadius=25&optProxType=city&selCity=49%7C17%7C123%7C8%7CVancouver&selPark=&txtCentralLatDeg=&txtCentralLatMin=&txtCentralLatSec=&txtCentralLongDeg=&txtCentralLongMin=&txtCentralLongSec=&txtLatDecDeg=&txtLongDecDeg=&StartYear=1840&EndYear=2021&optLimit=specDate&Year=1999&Month=1&Day=22&selRowPerPage=100
% tide data:
    % http://www.meds-sdmm.dfo-mpo.gc.ca/isdm-gdsi/twl-mne/inventory-inventaire/sd-ds-eng.asp?no=7795&user=isdm-gdsi&region=PAC
% Quadra sands permeability (2E-7 to 5E-3)
    % https://www.comoxvalleyrd.ca/sites/default/files/docs/Projects-Initiatives/4hydrogeological_assessment_of_comox_number_2_pump_station.pdf

%% October & November only
autumn.d = month(tWeather) == 10 | month(tWeather) == 11;
autumn.h = month(tTides) == 10 | month(tTides) == 11;
tWeatherAut = tWeather(autumn.d);
tTidesAut   = tTides(autumn.h);
precipAut   = precip(autumn.d);
tempMaxAut  = tempMax(autumn.d);
tempMinAut  = tempMin(autumn.d);
tempMeanAut = tempMean(autumn.d);
heightAut   = height(autumn.h);

%% March - May only
spring.d = month(tWeather) == 3 | month(tWeather) == 4 | month(tWeather) == 5;
tWeatherSpr = tWeather(spring.d);
tempMaxSpr  = tempMax(spring.d);
tempMinSpr  = tempMin(spring.d);
tempMeanSpr = tempMean(spring.d);
    clear tWeather tTides precip tempMax tempMin tempMean height
    
%% daily high tide
hoursHighAut = nan(length(tWeatherAut),1);
for id = 1:length(tWeatherAut)-1
    c = (tTidesAut >= tWeatherAut(id)) & (tTidesAut <  tWeatherAut(id+1));
    try                                                                     %#ok<TRYNC>
        hoursHighAut(id) = sum(heightAut(c) > heightBench);
    end
end
    clear c

%% precip avg
% the Quadra sands are highly permeable; 100m in 6 hours is feasible
% I'm assuming precipitation should be averaged over the prior 3 days,
% just as a bit of a guess

precipAvgAut = nan(length(tWeatherAut),1);
for id = 4:length(tWeatherAut) % prior 3 days
    precipAvgAut(id) = mean(precipAut(id-3:id));
end
precipAvgAut = precipAvgAut / 24; % units to mm/hr

flowIndexAut = precipAvgAut .* hoursHighAut; % units of mm

%% plot prep
c = unique(year(tWeatherAut));
c = c(1:end-2);

flowIndexPlotAut = nan(length(c),61); % 61 days in Oct + Nov
tempMeanPlotAut = nan(length(c),61);
for iy = 1:length(c)
    flowIndexPlotAut(iy,:) = flowIndexAut(year(tWeatherAut) == c(iy));
    tempMeanPlotAut(iy,:)  = tempMeanAut(year(tWeatherAut) == c(iy));
end

flowIndexPlotSpr = nan(length(c),92); % 92 days in Mar + Apr + May
tempMeanPlotSpr = nan(length(c),92);
for iy = 1:length(c)
    tempMeanPlotSpr(iy,:)  = tempMeanSpr(year(tWeatherSpr) == c(iy));
end
clear c

%% heatmap water flow plot
figure(1)
    clf
imagesc(flowIndexPlotAut);
set(gca, 'YTick', 1:3:22, 'YTickLabel', 1999:3:2020)
set(gca, 'XTick', [5:5:30,(5:5:30)+31], 'XTickLabel', [5:5:30,5:5:30])
ylabel('year')
xlabel('      October        |        November')

H = colorbar('southoutside');
H.Label.String = 'flow index (mm)';
H.Label.Position = [9.0938 -1 0];
    clear H
set(gcf,'Position',[100 100 800 400])

%% temperature plot autumn
figure(2)
    clf
imagesc(tempMeanPlotAut,'AlphaData',~isnan(tempMeanPlotAut));
set(gca, 'YTick', 1:3:22, 'YTickLabel', 1999:3:2020)
set(gca, 'XTick', [5:5:30,(5:5:30)+31], 'XTickLabel', [5:5:30,5:5:30])
ylabel('year')
xlabel('      October        |        November')

H = colorbar('southoutside');
H.Label.String = 'mean daily temperature (^oC)';
H.Label.Position = [5.5 -1 0];
    clear H
set(gcf,'Position',[100 100 800 400])

figure(3)
    clf
imagesc(tempMeanPlotSpr,'AlphaData',~isnan(tempMeanPlotSpr));
set(gca, 'YTick', 1:3:22, 'YTickLabel', 1999:3:2020)
set(gca, 'XTick', [5:5:30,(5:5:30)+31,(5:5:30)+61], ...
    'XTickLabel', [5:5:30,5:5:30,5:5:30])
ylabel('year')
xlabel(['         March                     |                      ', ...
    'April                     |                     May         '])

H = colorbar('southoutside');
H.Label.String = 'mean daily temperature (^oC)';
H.Label.Position = [9.5 -1 0];
    clear H
set(gcf,'Position',[100 100 800 400])

%% temperature plot spring
tTFYAut = 1998 + (1:size(flowIndexPlotAut,1))';
dataTFYAut = [mean(flowIndexPlotAut,2,'omitnan'), ...
         mean(tempMeanPlotAut,2,'omitnan'), ...
         std(flowIndexPlotAut,0,2,'omitnan'), ...
         std(tempMeanPlotAut,0,2,'omitnan')];
fieldsTFYAut = ["yearly mean of daily flow indices", ...
             "yearly mean of daily mean temps", ...
             "yearly stdev of daily flow indices", ...
             "yearly stdev of daily mean temps"];
         
save('tempFlowYearly.mat','dataTFYAut','fieldsTFYAut','tTFYAut')











