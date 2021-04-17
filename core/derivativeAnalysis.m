clear
close all
load dataCompiled returnsSpanish returnsIndian
load returnsKanaka
t = 2003:2019;

%% head
Spanish = returnsSpanish;
Indian  = returnsIndian;
c = any(tReturnsKanaka == t-4,2);
tKanaka = tReturnsKanaka(c,:);
Kanaka = returnsKanaka(c,:);
    clear c returnsSpanish returnsIndian returnsKanaka tReturnsKanaka

%% derivatives
d = @(x) x(2:end) - x(1:end-1);

d1t = strcat(string(t(1:end-1))," - ",string(t(2:end)));
d1tKanaka = strcat(string(t(1:end-1))," - ",string(t(2:end)));
d1Spanish = d(Spanish);
d1Indian  = d(Indian);
d1Kanaka  = d(Kanaka);

d2t = t(2:end-1); d2tKanaka = t(2:end-1);
d2Spanish = d(d1Spanish);
d2Indian  = d(d1Indian);
d2Kanaka  = d(d1Kanaka);

d3t = d1t(2:end-1); d3tKanaka = d1t(2:end-1);
d3Spanish = d(d2Spanish);
d3Indian  = d(d2Indian);
d3Kanaka  = d(d2Kanaka);

d4t = d2t(2:end-1); d4tKanaka = d2t(2:end-1);
d4Spanish = d(d3Spanish);
d4Indian  = d(d3Indian);
d4Kanaka  = d(d3Kanaka);

%% bar plot
colours = parula(8);
figure(1)
clf
subplot(3,1,1)
H = bar(categorical(d2t),d2Indian);
H.FaceColor = colours(1,:);
title(["chum returns to Indian River,";
    "highlighting returns exceeding interannual mean"])
ylabel('returns (thousands)')

subplot(3,1,2)
H = bar(categorical(d2t),d2Spanish);
H.FaceColor = colours(7,:);
title(["chum returns to Spanish Bank Creek,";
    "highlighting returns exceeding interannual mean"])
ylabel('returns (individuals)')

subplot(3,1,3)
H = bar(categorical(d2tKanaka),d2Kanaka);
H.FaceColor = colours(1,:);
title(["chum returns to Kanaka Creek,";
    "highlighting returns exceeding interannual mean"])
ylabel('returns (thousands)')

% text(1.9,6, ["returns 75%";"below mean";"\downarrow"])
% text(11.9,5, ["returns 75%";"below mean";"\downarrow"])
clear H

%% scatter plot
colours = parula(8);
figure(2)
    clf
subplot(1,2,1)
scatterCC(d2Indian,d2Spanish,colours(5,:), 0,-50)
title('second derivative of returns')
xlabel('Indian'''' (individuals)')
ylabel('Spanish'''' (individuals)')        

subplot(1,2,2)
scatterCC(d2Kanaka,d2Spanish,colours(3,:), .85,60)
title('second derivative of returns')
xlabel('Kanaka'''' four years offset (individuals)')
ylabel('Spanish'''' (individuals)')
    legend('off')





