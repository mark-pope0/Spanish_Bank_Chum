clear
close all

t = 2003:2019; % 2006 for West Van; else 2003
do = [  1; % 1:  compile data fresh
        0; % 2:  include all data, but set pre-2006 to nan
        0; % 3:  exclude non-chum salmon returns
        0; % 4:  square of individual signals
        0; % 5:  collinearity filter
        0; % 6:  multiple regression
        0; % 7:  coefficients & confidence plot
        0; % 8:  Great Matrix of Correlation Coefficients
        0; % 9:  Mini Matrix of Return Correlation Coefficients
        0; % 10: model comparison & plot
        0; % 11: returns to different streams plot
        0; % 12: Indian River comparison (not substantive)
        0; % 13: Burrard chum returns
        1; % 15: Indian Spanish Kanaka visualization
        ];
varOverride.add = ["Indian chum","Kanaka chum (+4","year"];
varOverride.rem = ["mean","stdev"];

%% head, squares, collinearity filter, variable override
if do(1)
    compileData(t', do(2)); 
end
load('dataCompiled','data','fields')
% no non-chum returns
if do(3)
    onlyRun = ~contains(fields,'returns') | contains(fields,'chum');
    data = data(:,onlyRun);
    fields = fields(:,onlyRun);
end
% squares
if do(4)
    c = reshape([1:length(fields);(1:length(fields))+length(fields)],[],1);
    data = [data,data.^2];
    fields = [fields,strcat(fields,"^2")];
    data = data(:,c); % collates so that vars ^2 and ^1 are together
    fields = fields(:,c);
        clear c
end
% collinearity filter
if do(5)
    onlyRun = collinFilter(data);
    data  = data(:,onlyRun);
    fields = fields(onlyRun);
end
    clear onlyRun
if ~isempty(varOverride.add)
    data = data(:,contains(fields,varOverride.add) & ...
        ~contains(fields,varOverride.rem));
    fields = fields(contains(fields,varOverride.add) & ...
        ~contains(fields,varOverride.rem));
end

%% multiple regression
c = ones(size(data,1),1);
dataZ = [zscore(data), c];
data  = [data, c]; clear c
fields = [fields, "ones"];

if do(6)
    load('dataCompiled','returnsSpanish')
    [b,bInt,~,~,ccStats] = regress(zscore(returnsSpanish),dataZ,.05);
    
    c(2,:) = string(ccStats);
    c(1,1:4) = ["r^2","F","p val","error variance"];
    ccStats = c; clear c
end

%% coefficients & confidence plot
if do(6) && do(7)
    figure(1)
    clf
    line(repmat(1:length(b),2,1),bInt','color',[.5 .5 .5])
    hold on
    scatter(1:length(b),b,[],[0 .3 .8],'+')
    c.a = length(bInt)+1;
    line([0,c.a],[0,0],'color',[.2 .2 .2])
    c.b = axis;
    c.c = max(abs(c.b(3:4)));
    axis([0 c.a, -c.c c.c])
    xticks(0:c.a)
    text(size(data,2)*.9, c.c*.9, strcat(ccStats(1,1)," = ", ...
            string(round(str2double(ccStats(2,1)),4))))
    text(size(data,2)*.85, c.c*.73, strcat(ccStats(1,3)," = ", ...
        string(round(str2double(ccStats(2,3)),4))))
        clear c
    xticklabels(["",fields])
    xtickangle(-60)
    ylabel('coefficient of z-scaled variables')
    
    if ~isempty(varOverride.add)
        title( ...
            'coefficients of variables from selected multiple regression')
    elseif min(t) < 2006
        title('coefficients of variables from multiple regression A')
    else
        title('coefficients of variables from multiple regression B')
    end
end

%% Great Matrix of Correlation Coefficients
if do(8)
    load('dataCompiled','returnsSpanish')
    figure(2)
        clf
    heatmapCC([returnsSpanish,dataZ(:,1:end-1)], ...
        ["returns Spanish chum",fields(1:end-1)])
    if min(t) < 2006
        title('correlation coefficients between variables, 2003 to 2019')
    else
        title('correlation coefficients between variables, 2006 to 2019')
    end
end

if do(9)
    load('dataCompiled','dataRet','fieldsRet')
    figure(3)
        clf
%     if min(t) < 2006
%         subplot(1,2,1)
%     end
    heatmapCC(zscore(dataRet),fieldsRet)
    if min(t) < 2006
        title('correlation coefficients between returns, 2003 to 2019')
    else
        title('correlation coefficients between returns, 2006 to 2019')
    end
%     if min(t) < 2006
%         subplot(1,2,2)
%         plotCorrCoeffs(zscore(dataRet([1,3:end],:)),fieldsRet)
%         title('correlation coefficients between returns, all but 2004')
%     end
end

%% model plot
if do(6) && do(10)
    load('dataCompiled','t')
    figure(4)
        clf
    [b,bInt,R,RInt,ccStats2] = regress(returnsSpanish,data,.05);
    predictedCI = returnsSpanish - RInt;
    
    bar(t,returnsSpanish,'facecolor',[.8 .8 .8])
    hold on
    line(repmat(t',2,1),predictedCI','color',[.5 .5 .5])
    scatter(t,returnsSpanish - R,[],[0 .3 .8],'+')
    % axis([t(1)-1,t(end)+1, -100,100])
    ylabel('number of fish')
    xlabel('year')
    c = axis;
    text(c(2)*.9984, c(4)*.9, strcat(ccStats(1,1)," = ", ...
            string(round(str2double(ccStats(2,1)),4))))
    text(c(2)*.998, c(4)*.82, strcat(ccStats(1,3)," = ", ...
        string(round(str2double(ccStats(2,3)),4))))
        clear c
        
    if ~isempty(varOverride.add)
        title('returns to Spanish Bank Creek, selected regression')
    elseif min(t) < 2006
        title('returns to Spanish Bank Creek, regression A')
    else
        title('returns to Spanish Bank Creek, regression B')
    end
end

%% returns to different streams plot
if do(11)
    load('dataCompiled','dataRet','fieldsRet')
    
    figure(5)
        clf
    subplot(2,1,1)
    plotReturnsToStreams(t, dataRet ./ mean(dataRet))
    ylabel('multiple of mean returns')
    title('salmon returns to Lower Mainland streams, scaled to mean annual return in each stream')
    legend(fieldsRet)
    
    subplot(2,1,2)
    plotReturnsToStreams(t, dataRet)
    set(gca,'yscale','log')
    ylabel('raw return count')
    title('salmon returns to Lower Mainland streams, raw count')
end

%% Indian analysis
if do(12)
    returnBar = 10000:10000:200000;
    returnsOverBar = max( ...
        data(:,fields == "returns Indian chum") - returnBar, 0);
    
    load('dataCompiled','returnsSpanish')
    figure(6)
        clf
    plotCorrCoeffs([returnsSpanish,returnsOverBar], ...
        ["returns Spanish chum",string(returnBar)])
    min(corrcoef([returnsSpanish,returnsOverBar(:,20)]),[],'all')
    if min(t) < 2006
        title('correlation coefficients between variables, 2003 to 2019')
    else
        title('correlation coefficients between variables, 2006 to 2019')
    end
end

%% Burrard chum returns analysis
if do(13)
    load('dataCompiled','dataRet','fieldsRet')
    c = contains(fieldsRet,'Indian') | ...
        contains(fieldsRet,'Kanaka') | ...
        contains(fieldsRet,'Cap') | ...
        contains(fieldsRet,'Brothers') | ...
        contains(fieldsRet,'coho');
    
    dataRet(:,c) = [];
    fieldsRet(:,c) = [];
        clear c
        
    figure(7)
        clf
    H = bar(t,dataRet);
    c.a = flipud(parula(length(fieldsRet)));
    for iS = 1:length(fieldsRet)
        H(iS).FaceColor = c.a(iS,:);
    end
    
    xticks(t)
    legend(fieldsRet,'location','southoutside','numcolumns',4)
    ylabel('returns (individuals)')
    c.b = axis;
    line([2006.5,2006.5],[c.b(3),c.b(4)], 'lineStyle','--', ...
        'lineWidth',1, 'color',c.a(contains(fieldsRet,'Lawson'),:), ...
        'HandleVisibility','off')
        % ^ date courtesy of John Barker, West Van Streamkeepers
    text(2006.75,c.b(4)-5,'Lawson estuary improvement','color',[.2 .2 .2])
        clear c
    
end

%% Indian Spanish Kanaka visualization
% note: this figure was modified to be light-on-dark for a poster.
%       the edits are not at all difficult to undo, if you prefer the more
%       conventional dark-on-light look of the other figures.
if do(14)
    load dataCompiled returnsSpanish returnsIndian
    load returnsKanaka
    returnsIndian = returnsIndian / 1000;
    returnsKanaka = returnsKanaka / 1000;
    c = any(tReturnsKanaka == t-4,2);
    tReturnsKanaka = tReturnsKanaka(c,:);
    returnsKanaka = returnsKanaka(c,:);
        clear c

    returnsIndianBar = [min(mean(returnsIndian),returnsIndian), ...
        max(0,returnsIndian - mean(returnsIndian))];
    returnsSpanishBar = [min(mean(returnsSpanish),returnsSpanish), ...
        max(0,returnsSpanish - mean(returnsSpanish))];
    returnsKanakaBar = [min(mean(returnsKanaka),returnsKanaka), ...
        max(0,returnsKanaka - mean(returnsKanaka))];
    colours = ["#33729b","#508bb6", "#98c2b3","#b3decf"];
    txtC = '#f4f1cc';
    bkgC = '#20232e';
    
    figure(9)
        clf
    subplot(3,1,1)
    H = bar(categorical(t),returnsIndianBar,'stacked');
    H(1).FaceColor = colours(1); H(2).FaceColor = colours(2);
    title(["chum returns to Indian River,";
        "highlighting returns exceeding interannual mean"], 'color',txtC)
    ylabel('returns (thousands)')
%     text(1.9,275, "\downarrow returns 200% over mean", ...
%         'color',txtC, 'fontname','Montserrat')
%     text(6.9,215, "\downarrow returns 130% over mean", ...
%         'color',txtC, 'fontname','Montserrat')
%     text(11.9,75, ["returns 90% below mean";"\downarrow"], ...
%         'color',txtC, 'fontname','Montserrat')
    set(gca,'color',bkgC, 'xcolor',txtC, 'ycolor',txtC, ...
        'fontname','Montserrat') % Montserrat is a really good free font
    
    subplot(3,1,2)
    H = bar(categorical(t),returnsSpanishBar,'stacked');
    H(1).FaceColor = colours(3); H(2).FaceColor = colours(4);
    title(["chum returns to Spanish Bank Creek,";
        "highlighting returns exceeding interannual mean"], 'color',txtC)
    ylabel('returns (individuals)')
%     text(2.6,45, "\leftarrow returns 900% over mean", ...
%         'color',txtC, 'fontname','Montserrat')
%     text(6.9,6, "\downarrow 0 returns", ...
%         'color',txtC, 'fontname','Montserrat')
%     text(10.6,20, ["returns 40% over mean";"         \downarrow"], ...
%         'color',txtC, 'fontname','Montserrat')
    set(gca,'color',bkgC, 'xcolor',txtC, 'ycolor',txtC, ...
        'fontname','Montserrat')
    
    subplot(3,1,3)
    H = bar(categorical(tReturnsKanaka),returnsKanakaBar,'stacked');
    H(1).FaceColor = colours(1); H(2).FaceColor = colours(2);
    title(["chum returns to Kanaka Creek, (offset by four years)";
        "highlighting returns exceeding interannual mean"], 'color',txtC)
    ylabel('returns (thousands)')
%     text(1.9,6, ["returns 75%";"below mean";"\downarrow"], ...
%         'color',txtC, 'fontname','Montserrat')
%     text(11.9,5, ["returns 75%";"below mean";"\downarrow"], ...
%         'color',txtC, 'fontname','Montserrat')
    set(gca,'color',bkgC, 'xcolor',txtC, 'ycolor',txtC, ...
        'fontname','Montserrat')
    set(gcf,'color',bkgC)
    exportgraphics(gcf,'figsPoster/threeStreamsDark.png', ...
        'Resolution',900, 'BackgroundColor',bkgC)
    clear H colours txtC bkgC
    
    
    
    
end







