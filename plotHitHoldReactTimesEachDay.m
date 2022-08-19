function plotHitHoldReactTimesEachDay(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath)
           
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
        
        hitInds = strcmp(input.trialOutcomeCell, 'success');
        missInds = strcmp(input.trialOutcomeCell, 'ignore');
        faInds = strcmp(input.trialOutcomeCell, 'failure');
            
        arrHitHoldTimes = arrHoldTimes(hitInds); % exclude misses when plotting to be able to see decrease in hold/reaction time
        arrHitReactTimes = arrReactTimes(hitInds);
        
        maxY = 2000; %max(max(arrHitHoldTimes),max(arrHitReactTimes))+1000;
        f = figure('Name', ['Hit Hold/React times along the same session']);
        set(f, 'Position', [1500 500 800 400]);
        hold on
        subplot(1,2,1)
        c = linspace(1,5,length(arrHitHoldTimes));
        scatter([1:length(arrHitHoldTimes)], arrHitHoldTimes,20,c,'filled');
        grid on;
        ylim([0 maxY]);
        title('Hold times')

        subplot(1,2,2)
        c = linspace(1,5,length(arrHitReactTimes));
        scatter([1:length(arrHitReactTimes)], arrHitReactTimes,20,c,'filled');
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
        
        saveas(f, strcat(sprintf('out/Mouse%s%s_HitHoldReactTimesDay%s',globalMiceIdPrefix,mouseId,trainingDay), '.png'));            
    end
end