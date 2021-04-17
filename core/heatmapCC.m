function heatmapCC(data,fields)

corrCoeffs = corrcoef(data);
imagesc(corrCoeffs,[-1 1])
xticks(1:length(fields)+1); yticks(1:length(fields)+1)
xticklabels(fields);
yticklabels(fields);
xtickangle(45); ytickangle(45);
set(gca,'XAxisLocation','top');
colorbar
colormap([flipud(bone(128) ./ sum(bone(128),2) .* sum(pink(128),2)); ...
    pink(128)]);
daspect([1 1 1])

end