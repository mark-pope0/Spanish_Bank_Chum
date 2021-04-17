function runThese = collinFilter(data)

if size(data,2) >= size(data,1) % only run the collin if rank deficient
    runThese = (1:size(data,1)-2)';
    for iV = (size(data,1):size(data,2))
        runThese = [runThese;iV];
        [~,condIdx,VarDecomp] = collintest(data(:,runThese),'display','off');
        while max(VarDecomp(:)) > .5 && max(condIdx) > 30 || ...
            length(runThese) >= size(data,1)
            runThese = runThese(~any(VarDecomp == max(VarDecomp(:))));
            [~,condIdx,VarDecomp] = collintest(data(:,runThese),'display','off');
        end
    end
    
    while length(runThese) >= size(data,1) - 1
        runThese = runThese(~any(VarDecomp == max(VarDecomp(:))));
        [~,~,VarDecomp] = collintest(data(:,runThese),'display','off');
    end
else
    runThese = 1:size(data,2);
end
    

end


    