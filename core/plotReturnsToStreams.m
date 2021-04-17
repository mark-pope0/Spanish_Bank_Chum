function plotReturnsToStreams(t,y)

H = bar(t,y,'facecolor','flat');

c = parula(length(H));
for is = 1:length(H)
    H(is).CData = c(is,:);
end
clear c

set(gca,'yGrid','on')
xticks(t)
xlabel('year')
