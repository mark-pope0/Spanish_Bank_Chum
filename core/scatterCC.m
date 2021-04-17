function scatterCC(x, y, markerColour, textX, textY)

% [num,dem] = rat(parulaFraction);
% colours = parula(dem);

c = fitlm(x,y);
H = plot(c);
    H(1).Color = markerColour;
    H(2).Color = [.5 .5 .5];
    H(3).Color = [.5 .5 .5];
    H(4).Color = [.5 .5 .5];
legend('off')
text(textX,textY,strcat("r^2 = ",string(c.Rsquared.ordinary)))
        
end