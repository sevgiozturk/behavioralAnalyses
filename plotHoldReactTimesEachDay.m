function plotHoldReactTimesEachDay(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath)
           
    somePlotThreshold = 3000;
    nAvg = 5; % Average over evry 5 trials
    
    for j=1:length(arrDays)
        fileName = dirStruct(arrDays(j)).name;
        fullFilename = [dataPath fileName];
        data = load(fullFilename);
        input = data.input;
        fixedHold = input.fixedReqHoldTimeMs;
        trainingDay =  extractBetween(fileName,[globalMiceIdPrefix mouseId '-'],'-');
        trainingDay = trainingDay{:};

        arrHoldTimes = cell2mat(input.holdTimesMs);
        arrReactTimes = cell2mat(input.reactTimesMs);
        arrHoldTimes = arrHoldTimes(arrHoldTimes<somePlotThreshold); % exclude misses when plotting to be able to see decrease in hold/reaction time
        arrReactTimes = arrReactTimes(arrReactTimes<somePlotThreshold);
        %arrAvgHoldTimes = arrayfun(@(idx) mean(arrHoldTimes(idx:idx+nAvg-1)),1:nAvg:length(arrHoldTimes)-nAvg+1)'; % the averaged vector
        %arrAvgReactTimes = arrayfun(@(idx) mean(arrReactTimes(idx:idx+nAvg-1)),1:nAvg:length(arrReactTimes)-nAvg+1)'; % the averaged vector
        arrAvgHoldTimes = arrHoldTimes;
        arrAvgReactTimes = arrReactTimes;
        
        maxY = max(max(arrAvgHoldTimes),max(arrAvgReactTimes));
        f = figure('Name', ['Hold/React times along the same session']);
        set(f, 'Position', [1500 500 800 400]);
        hold on
        subplot(1,2,1)
        c = linspace(1,5,length(arrAvgHoldTimes));
        scatter([1:length(arrAvgHoldTimes)], arrAvgHoldTimes,20,c,'filled');
        grid on;
        ylim([0 maxY]);
        title('Hold times')

        subplot(1,2,2)
        c = linspace(1,5,length(arrAvgReactTimes));
        scatter([1:length(arrAvgReactTimes)], arrAvgReactTimes,20,c,'filled');
        grid on;
        ylim([0 maxY]);
        title('React times')
        
        % Give common xlabel, ylabel and title to your figure
        han=axes(f,'visible','off');         
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        ylabel(han,'Time (ms)');
        xlabel(han,'Trials');

        bigTitle = sprintf('Mouse: %s%s day=%s',globalMiceIdPrefix,mouseId,trainingDay);
        %suptitle(bigTitle)
        text(0.33, 1.07, bigTitle,'FontSize', 14, 'FontWeight', 'bold')
        saveas(f, strcat(sprintf('out/Mouse%s%s_HoldReactTimesDay%s',globalMiceIdPrefix,mouseId,trainingDay), '.png'));            
    end
end