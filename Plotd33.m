%
% Plot "d33" vals vs. spot no.
function Graph = Plotd33(SpotStruct)
%
%
%
%
%
%
    SpotNo = fieldnames(SpotStruct);

    for i = 1:length(SpotNo)

        d33(i) = SpotStruct.(char(SpotNo(i))).finalVals(1);
        err(i) = SpotStruct.(char(SpotNo(i))).finalVals(3);
    end

    avg = mean(d33);

    Graph = errorbar(d33, err, 'LineWidth',2);
    hold on
    set(gca, 'XTick', 1:numel(SpotNo))
    set(gca,'XTickLabel',SpotNo)
    ylabel('d33 (nm/V)'); xlabel('Spot No.');
    yline(avg)
    ax=gca; ax.YAxis.Exponent = -3;

end


