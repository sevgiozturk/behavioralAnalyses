function plotDailyHoldReactCDFs(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath) 

    f = figure('Name', [globalMiceIdPrefix mouseId]);
    set(f, 'Position', [1500 50 800 400]);
    hold on
    
    for j=1:length(arrDays)
            fileName = dirStruct(arrDays(j)).name;
            fullFilename = [dataPath fileName];
            data = load(fullFilename);
            input = data.input;

            xMax = input.fixedReqHoldTimeMs+500;
%                         
%             hitInds = strcmp(input.trialOutcomeCell, 'success');
%             missInds = strcmp(input.trialOutcomeCell, 'ignore');
%             faInds = strcmp(input.trialOutcomeCell, 'failure');
            
            arrHoldTimes = cell2mat(input.holdTimesMs);
            arrReactTimes = cell2mat(input.reactTimesMs);
            trialCount = length(arrHoldTimes);
            arrHoldTimes = arrHoldTimes(ceil(2*trialCount/3):end); % Last 1/3 of trials, Heffley2018 Fig S2c 
            arrReactTimes = arrReactTimes(ceil(2*trialCount/3):end);
            
%             arrHitHoldTimes = arrHoldTimes(hitInds);
%             arrMissHoldTimes = arrHoldTimes(missInds);
%             arrFaHoldTimes = arrHoldTimes(faInds);

            ax1 = subplot(1,2,1);
            hold on
            h = cdfplot(arrHoldTimes);
            set(h, 'LineWidth',2);
            xlim([0 xMax]);
            ylim([0 1]);
            legend('Empirical CDF','Standard Normal CDF','Location','best')
            title('Hold Time CDF')
            xlabel('')
            
            ax2 = subplot(1,2,2);
            hold on
            h = cdfplot(arrReactTimes);            
            set(h, 'LineWidth',2);
            xlim([-400 xMax]);
            ylim([0 1]);
            title('Reaction Time CDF')          
            xlabel('')
    end
    
    legend(ax1,'day '+string(arrDays));
    legend(ax2,'day '+string(arrDays));
    
    % Give common xlabel, ylabel and title to your figure
    han=axes(f,'visible','off'); 
    han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    ylabel(han,'');
    xlabel(han,'Time (ms)');
    
    bigTitle = sprintf('Mouse: %s%s',globalMiceIdPrefix,mouseId);
    %suptitle(bigTitle)
    text(0.43,1.06,bigTitle,'FontSize', 14, 'FontWeight', 'bold')
    
    saveas(f, strcat(sprintf('out/Mouse%s%s_DailyHoldReactCDFs',globalMiceIdPrefix,mouseId), '.png'));
end