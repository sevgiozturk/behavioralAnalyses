function plotDailyMeanHoldReactTimes(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath)
       
    dailyMeanHoldTimes = zeros(1,length(arrDays));
    dailyMeanReactTimes = zeros(1,length(arrDays));
    
    dailySemHoldTimes = zeros(1,length(arrDays));
    dailySemReactTimes = zeros(1,length(arrDays));
    
    for j=1:length(arrDays)
            fileName = dirStruct(arrDays(j)).name;
            fullFilename = [dataPath fileName];
            data = load(fullFilename);
            input = data.input;
            
            arrHoldTimes = cell2mat(input.holdTimesMs);
            arrReactTimes = cell2mat(input.reactTimesMs);
            
            dailyMeanHoldTimes(j) = mean(arrHoldTimes);
            dailyMeanReactTimes(j) = mean(arrReactTimes);
            
            dailySemHoldTimes(j) = std(double(arrHoldTimes))/sqrt(length(arrHoldTimes));
            dailySemReactTimes(j) = std(double(arrReactTimes))/sqrt(length(arrReactTimes));
            
    end
    
    maxY = max(max(dailyMeanHoldTimes),max(dailyMeanReactTimes))+1000;
    f = figure('Name', ['Daily change in Hold/React times']);
    set(f, 'Position', [1500 500 800 400]);
    hold on        
    subplot(1,2,1)
    scatter(arrDays, dailyMeanHoldTimes,'filled')
    hold on
    errorbar(arrDays, dailyMeanHoldTimes, dailySemHoldTimes,'o');
    grid on;
    set(gca, 'XTick', arrDays);
    ylim([0 maxY]);
    title('Hold times')
    
    subplot(1,2,2)
    scatter(arrDays, dailyMeanReactTimes,'filled')
    hold on
    errorbar(arrDays, dailyMeanReactTimes, dailySemReactTimes,'o');
    grid on;
    set(gca, 'XTick', arrDays);
    ylim([0 maxY]);
    title('React times')
        
    % Give common xlabel, ylabel and title to your figure
    han=axes(f,'visible','off');         
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    ylabel(han,'Time (ms)');
    xlabel(han,'Days');
    
    bigTitle = sprintf('Mouse: %s%s',globalMiceIdPrefix,mouseId);
    %suptitle(bigTitle) % suptitle got weird! 'Axes cannot be a child of Legend' error in suptitle function!
    text(0.43,1.05,bigTitle,'FontSize', 14, 'FontWeight', 'bold')
        
    saveas(f, strcat(sprintf('out/Mouse%s%s_DailyHoldReactTimes',globalMiceIdPrefix,mouseId), '.png'));
end