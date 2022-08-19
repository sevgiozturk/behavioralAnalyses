function plotDailyBehavioralOutcomeCounts(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath)

        dailyTrialCount = zeros(1,length(arrDays));
        dailyHitCount = zeros(1,length(arrDays));
        dailyMissCount = zeros(1,length(arrDays));
        dailyFaCount = zeros(1,length(arrDays));
        
        for j=1:length(arrDays)
            fileName = dirStruct(arrDays(j)).name;
            fullFilename = [dataPath fileName];
            data = load(fullFilename);
            input = data.input;
            
            hitInds = strcmp(input.trialOutcomeCell, 'success');
            missInds = strcmp(input.trialOutcomeCell, 'ignore');
            faInds = strcmp(input.trialOutcomeCell, 'failure');
            
            arrHoldTimes = cell2mat(input.holdTimesMs);
            arrReactTimes = cell2mat(input.reactTimesMs);

%             arrHitHoldTimes = arrHoldTimes(hitInds);
%             arrMissHoldTimes = arrHoldTimes(missInds);
%             arrFaHoldTimes = arrHoldTimes(faInds);
%             
%             arrHitReactTimes = arrReactTimes(hitInds);
%             arrMissReactTimes = arrReactTimes(missInds);
%             arrFaReactTimes = arrReactTimes(faInds);
            
            nTrialCount = length(input.trialOutcomeCell);
            nHit = sum(hitInds);
            nMiss = sum(missInds);
            nFA = sum(faInds);
                                    
            dailyTrialCount(j) = nTrialCount;
            dailyHitCount(j) = nHit;
            dailyMissCount(j) = nMiss;
            dailyFaCount(j) = nFA;
        end        
        
        
        f=figure('Name','Daily Change in Behavioral Outcomes');
        set(f, 'Position', [1500 500 800 800]);
        subplot(2,2,1)
        scatter(arrDays,dailyTrialCount,'filled');
        grid on;
        title('Trial count');
        subplot(2,2,2)
        scatter(arrDays,dailyHitCount./dailyTrialCount*100,'filled')
        grid on;
        ylim([0 100]);
        title('Hit rate (%)');
        subplot(2,2,3)
        scatter(arrDays,dailyMissCount./dailyTrialCount*100,'filled')
        grid on;
        ylim([0 100]);
        title('Miss rate (%)');
        subplot(2,2,4)
        scatter(arrDays,dailyFaCount./dailyTrialCount*100,'filled')
        grid on;
        ylim([0 100]);
        title('False alarm rate (%)');
        bigTitle = sprintf('Mouse: %s%s',globalMiceIdPrefix,mouseId);        
        suptitle(bigTitle)
        
        % Give common xlabel, ylabel and title to your figure
        han=axes(f,'visible','off'); 
        han.Title.Visible='on';
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        ylabel(han,'');
        xlabel(han,'Days');
        %title(han,bigTitle);
        
        saveas(f, strcat(sprintf('out/Mouse%s%s_DailyBehavioralOutcomeCounts',globalMiceIdPrefix,mouseId), '.png'));

end