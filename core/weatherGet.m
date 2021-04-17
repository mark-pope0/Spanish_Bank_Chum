clear

q.id.Atkinson = '844';
q.id.Harbour  = '888';
q.year  = 1999:2021;
q.month = 1;
q.day   = 1;

precip   = [];
tempMax   = [];
tempMin   = [];
tempMean = [];
tWeather = [];
for iy = q.year
    url = ['https://climate.weather.gc.ca/climate_data/bulk_data_e.html?', ...
        'format=csv','&stationID=',q.id.Harbour,'&Year=',num2str(iy), ...
        '&Month=',num2str(q.month),'&Day=',num2str(q.day), ...
        '&timeframe=','2','&submit=','Download+Data'];
    
    % websave('a.csv',url);
    c = webread(url,weboptions('ContentType','table'));
    precip   = [precip;   table2array(c(:,'TotalPrecip_mm_'))];             %#ok<AGROW>
    tempMax  = [tempMax;  table2array(c(:,'MaxTemp__C_'))];                 %#ok<AGROW>
    tempMin  = [tempMin;  table2array(c(:,'MinTemp__C_'))];                 %#ok<AGROW>
    tempMean = [tempMean; table2array(c(:,'MeanTemp__C_'))];                %#ok<AGROW>
    tWeather       = [tWeather;datetime(table2array(c(:,'Date_Time')))];                  %#ok<AGROW>
    iy
end
    clear c q iy url
tWeather = datetime(tWeather,'TimeZone','America/Los_Angeles');

save weather.mat


