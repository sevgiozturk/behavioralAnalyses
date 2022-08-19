function plotHoldReactTimesAccrossSessions(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath)
    
    maxSessionCount = 100; % increase if you have more days of data
    maxTrialCount = 1000; % increase if you have more trial count in a day
    plotted = 0; % flag if plotted
    globalFixedHold = 0;
    dailyHoldTimes = nan(maxSessionCount,maxTrialCount); % sessions(days) x nTrialCount
    dailyReactTimes = nan(maxSessionCount,maxTrialCount);
    for j=1:length(arrDays)
            fileName = dirStruct(arrDays(j)).name;
            fullFilename = [dataPath fileName];
            data = load(fullFilename);
            input = data.input;
            
            fixedHold = input.fixedReqHoldTimeMs;
            %nTrialCount = length(input.trialOutcomeCell);
            arrHoldTimes = cell2mat(input.holdTimesMs);
            arrReactTimes = cell2mat(input.reactTimesMs);
                        
            if fixedHold~=globalFixedHold && j~=1 % if fixedHold changed among the sessions, plot them seperately
                maxY = 2000; %max(max(max(dailyHoldTimes)),max(max(dailyReactTimes)))+3000;
                f = figure('Name', 'Hold/React times accross sessions');
                set(f, 'Position', [2000 500 1600 1000]);
                hold on

                %%%%%%%%%%% Calculate mean+-sem across sessions(days) for the same trial orders %%%%%%%%%%
                meanHoldTimesAcrSess = nanmean(dailyHoldTimes,1);
                meanHoldTimesAcrSess = meanHoldTimesAcrSess(~isnan(meanHoldTimesAcrSess));

                stdHoldTimesAcrSess = nanstd(dailyHoldTimes,1);
                stdHoldTimesAcrSess = stdHoldTimesAcrSess(~isnan(stdHoldTimesAcrSess));
                nSessions = sum(~isnan(dailyHoldTimes),1);
                nSessions = nSessions(nSessions~=0);
                semHoldTimesAcrSess = stdHoldTimesAcrSess./sqrt(nSessions);

                meanReactTimesAcrSess = nanmean(dailyReactTimes,1);
                meanReactTimesAcrSess = meanReactTimesAcrSess(~isnan(meanReactTimesAcrSess));

                stdReactTimesAcrSess = nanstd(dailyReactTimes,1);
                stdReactTimesAcrSess = stdReactTimesAcrSess(~isnan(stdReactTimesAcrSess));
                nSessions = sum(~isnan(dailyReactTimes),1);
                nSessions = nSessions(nSessions~=0);
                semReactTimesAcrSess = stdReactTimesAcrSess./sqrt(nSessions);
                %%%%%%%%%%% Calculate mean+-sem across sessions(days) for the same trial orders %%%%%%%%%%

                xs = [1:length(meanHoldTimesAcrSess)];
                subplot(1,2,1)
                scatter(xs, meanHoldTimesAcrSess,'filled')
                grid on;
                hold on
                errorbar(xs, meanHoldTimesAcrSess, semHoldTimesAcrSess,'o');
                %set(gca, 'XTick', arrDays);
                ylim([0 maxY]);
                title('Hold times')

                xs = [1:length(meanReactTimesAcrSess)];
                subplot(1,2,2)
                scatter(xs, meanReactTimesAcrSess,'filled')
                grid on;
                hold on
                errorbar(xs, meanReactTimesAcrSess, semReactTimesAcrSess,'o');
                %set(gca, 'XTick', arrDays);
                ylim([0 maxY]);
                title('React times')

                bigTitle = sprintf('Mouse: %s%s with fixedHoldTime=%d',globalMiceIdPrefix,mouseId,globalFixedHold);
                suptitle(bigTitle)

                % Give common xlabel, ylabel and title to your figure
                han=axes(f,'visible','off');         
                han.XLabel.Visible='on';
                han.YLabel.Visible='on';
                ylabel(han,'Time (ms)');
                xlabel(han,'Trials');

                saveas(f, strcat(sprintf('out/Mouse%s%s_HoldReactTimesAccrSess_fixed%d',globalMiceIdPrefix,mouseId,globalFixedHold), '.png'));
                plotted = 1;
                
                dailyHoldTimes = nan(maxSessionCount,maxTrialCount); % empty arrays to save new upcoming data with different fixedHoldTime
                dailyReactTimes = nan(maxSessionCount,maxTrialCount);
            end  
            
            dailyHoldTimes(j,1:length(arrHoldTimes)) = arrHoldTimes;
            dailyReactTimes(j,1:length(arrReactTimes)) = arrReactTimes;
            globalFixedHold = fixedHold;
            plotted = 0;
    end  
    
    if ~plotted % might have the same fixedHoldTime along the sessions
            maxY = 2000; %max(max(max(dailyHoldTimes)),max(max(dailyReactTimes)))+3000;
            f = figure('Name', 'Hold/React times accross sessions');
            set(f, 'Position', [1000 0 1600 1000]);
            hold on

            %%%%%%%%%%% Calculate mean+-sem across sessions(days) for the same trial orders %%%%%%%%%%
            meanHoldTimesAcrSess = nanmean(dailyHoldTimes,1);
            meanHoldTimesAcrSess = meanHoldTimesAcrSess(~isnan(meanHoldTimesAcrSess));
            
            stdHoldTimesAcrSess = nanstd(dailyHoldTimes,1);
            stdHoldTimesAcrSess = stdHoldTimesAcrSess(~isnan(stdHoldTimesAcrSess));
            nSessions = sum(~isnan(dailyHoldTimes),1);
            nSessions = nSessions(nSessions~=0);
            semHoldTimesAcrSess = stdHoldTimesAcrSess./sqrt(nSessions);
            
            meanReactTimesAcrSess = nanmean(dailyReactTimes,1);
            meanReactTimesAcrSess = meanReactTimesAcrSess(~isnan(meanReactTimesAcrSess));
            
            stdReactTimesAcrSess = nanstd(dailyReactTimes,1);
            stdReactTimesAcrSess = stdReactTimesAcrSess(~isnan(stdReactTimesAcrSess));
            nSessions = sum(~isnan(dailyReactTimes),1);
            nSessions = nSessions(nSessions~=0);
            semReactTimesAcrSess = stdReactTimesAcrSess./sqrt(nSessions);
            %%%%%%%%%%% Calculate mean+-sem across sessions(days) for the same trial orders %%%%%%%%%%
                        
            xs = [1:length(meanHoldTimesAcrSess)];
            subplot(1,2,1)
            scatter(xs, meanHoldTimesAcrSess,'filled')
            grid on;
            hold on
            errorbar(xs, meanHoldTimesAcrSess, semHoldTimesAcrSess,'o');
            %set(gca, 'XTick', arrDays);
            ylim([0 maxY]);
            title('Hold times')

            xs = [1:length(meanReactTimesAcrSess)];
            subplot(1,2,2)
            scatter(xs, meanReactTimesAcrSess,'filled')
            grid on;
            hold on
            errorbar(xs, meanReactTimesAcrSess, semReactTimesAcrSess,'o');
            %set(gca, 'XTick', arrDays);
            ylim([0 maxY]);
            title('React times')
            
            % Give common xlabel, ylabel and title to your figure
            han=axes(f,'visible','off');         
            han.XLabel.Visible='on';
            han.YLabel.Visible='on';
            ylabel(han,'Time (ms)');
            xlabel(han,'Trials');

            bigTitle = sprintf('Mouse: %s%s with fixedHoldTime=%d',globalMiceIdPrefix,mouseId,globalFixedHold);
            %suptitle(bigTitle)
            text(0.43, 1.06, bigTitle,'FontSize', 14, 'FontWeight', 'bold')

            saveas(f, strcat(sprintf('out/Mouse%s%s_HoldReactTimesAccrSess_fixed%d',globalMiceIdPrefix,mouseId,fixedHold), '.png'));
    end
    
end