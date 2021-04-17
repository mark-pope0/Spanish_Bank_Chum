clear
load bugsUnscrapable.mat % dates & survey nums cannot be scraped, 
                         % so they must be loaded externally
fieldsBugs = ["abundance"; "density"; "pollution tolerant index"; ...
    "EPT index"; "EPT to total ratio"; "predominant taxon ratio"];

%% scraping
dataBugs = nan(6,length(tBugs));
for iy = 1:length(tBugs)
    clear temp
    A = webread( ...
        ['http://www.streamkeepers.info/module04/', ...
        'report04_data_display.php?recordID=', num2str(iSN(iy))]);
    
    temp.a = extractBetween(A,'ABUNDANCE: <span class="data_calc">','</span>');
    temp.b = extractBetween(A,'<span class="data_calc_result">','</span>');
    if length(temp.a) ~= 1 || length(temp.b) ~= 6
        error(['bad length for',num2str(year(tBugs(iy)))])
    end
    
    dataBugs(:,iy) = cellfun(@str2double,temp.b);
    dataBugs(2:6,iy) = dataBugs(1:5,iy);
    dataBugs(1,iy) = str2double(temp.a);
    
end
dataBugs = dataBugs';
fieldsBugs = fieldsBugs';
tBugs = tBugs';

save('bugsScraped.mat','dataBugs','fieldsBugs','tBugs')

