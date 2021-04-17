function compileData(t, allVars2003)

load bugsScraped.mat
load tempFlowYearly.mat
load returnsSpanish.mat
load releasesSpanish.mat
load returnsIndian.mat
load returnsKanaka.mat
load returnsCapilano.mat
load returnsWestVan.mat % data held by West Van Streamkeepers;
                        % contact John Barker to obtain
% West Van estuaries
numWVEstuaries = zeros(length(t),1); % dates courtesy of John Barker,
    numWVEstuaries(t >= 2007) = 1;   % West Van Streamkeepers
    numWVEstuaries(t >= 2014) = 2;
    numWVEstuaries(t >= 2016) = 3;
    numWVEstuaries(t >= 2017) = 4;
% bug counts
tBugs = year(tBugs)'; dataBugs = dataBugs';
dataBugs(:,6) = 1-dataBugs(:,6);
fieldsBugs(6) = "1 - predom. taxon ratio";
fieldsBugs = strcat("bug count ",fieldsBugs);
dataBugs = interp1(tBugs,dataBugs,t);
% weather
dataTFYAut  = dataTFYAut(any(t' == tTFYAut,2),:);
% returns Spanish
returnsSpanish = returnsSpanish(any(t' == tReturnsSpanish,2));
% releases Spanish + 4 yrs
tReleasesSpanish = tReleasesSpanish + 4; % offset releases by 4 years
releasesSpanish = releasesSpanish(any(t' == tReleasesSpanish,2));
releasesSpanishWeight = releasesSpanishWeight(any(t' == tReleasesSpanish,2));
% returns Indian
returnsIndian = interp1(tReturnsIndian(~isnan(returnsIndian)), ...
    returnsIndian(~isnan(returnsIndian)),t);
% returns Kanaka
returnsKanaka0 = returnsKanaka(any(t' == tReturnsKanaka,2));
returnsKanaka4 = returnsKanaka(any((t-4)' == tReturnsKanaka,2));
% returns Capilano
c = interp1(tReturnsCapilano(~isnan(returnsCapilano(:,9))), ...
    returnsCapilano(~isnan(returnsCapilano(:,9)),9),t);
returnsCapilano = returnsCapilano(any(t' == tReturnsCapilano,2),:);
returnsCapilano(:,9) = c;
    clear c
returnsCapSimpl = [sum(returnsCapilano(:,1:4),2), ...
    sum(returnsCapilano(:,5:6),2), returnsCapilano(:,7:end)];
fieldsReturnsCapSimpl = ["returns Cap coho", "returns Cap chinook", ...
    "returns Cap summer steelhead", "returns Cap winter steelhead", ...
    "returns Cap chum", "returns Cap pink"];  

%% assembly
data = [t, numWVEstuaries, dataBugs, dataTFYAut, releasesSpanish, ...
    returnsIndian, returnsKanaka0, returnsKanaka4, returnsCapSimpl];
fields = ["year", "number of West Van estuary improvements", ...
    fieldsBugs', fieldsTFYAut', "releases Spanish (+4 yr)" ...
    "returns Indian chum", "returns Kanaka chum", ...
    "returns Kanaka chum (+4 yr)", fieldsReturnsCapSimpl];

dataRet = [returnsSpanish, returnsIndian, returnsKanaka0, returnsCapSimpl];
fieldsRet = ["Spanish chum", "Indian chum", "Kanaka chum", ...
    "Capilano coho", "Capilano chinook", "Capilano summer steelhead", ...
    "Capilano winter steelhead", "Capilano chum", "Capilano pink"];

% returns West Van
if min(t) == 2006 || allVars2003
    returnsWestVan = [nan(2006 - min(t), size(returnsWestVan,2)); ...
        returnsWestVan];
    tReturnsWestVan = [(min(t):2005)'; tReturnsWestVan];
    returnsWestVan = returnsWestVan(any(t' == tReturnsWestVan,2),:);
    data = [data, returnsWestVan];
    fields = [fields, strcat("returns ", fieldsReturnsWestVan)];
    dataRet = [dataRet, returnsWestVan];
    fieldsRet = [fieldsRet, fieldsReturnsWestVan];
end

save('dataCompiled')
end