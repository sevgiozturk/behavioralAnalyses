function plotDailyHoldReactPDFs(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath)
        
        nColumns = 4;
        binWidth = 50;
        widerBinWidth = 150;
        xMinReact = -600;
        xMaxReact = 5000;
        yMax = 70;

        row_col ={length(arrDays),nColumns};
        fig = figure('Name', [globalMiceIdPrefix mouseId]);
        set(fig, 'Position', [1500 50 800 1950]);

        
        dailyHoldTimes = [];
        dailyReactTimes = [];
        for j=1:length(arrDays)
            fileName = dirStruct(arrDays(j)).name;
            fullFilename = [dataPath fileName];
            data = load(fullFilename);
            input = data.input;

            xMax = input.fixedReqHoldTimeMs+2000;
                        
            hitInds = strcmp(input.trialOutcomeCell, 'success');
            missInds = strcmp(input.trialOutcomeCell, 'ignore');
            faInds = strcmp(input.trialOutcomeCell, 'failure');
            
            arrHoldTimes = cell2mat(input.holdTimesMs);
            arrReactTimes = cell2mat(input.reactTimesMs);

            arrHitHoldTimes = arrHoldTimes(hitInds);
            arrMissHoldTimes = arrHoldTimes(missInds);
            arrFaHoldTimes = arrHoldTimes(faInds);

            axH = subplot(row_col{:},nColumns*(j-1)+1);
            set(axH, 'Visible', 'off')
            trainingDay =  extractBetween(fileName,[globalMiceIdPrefix mouseId '-'],'-');
            trainingDay = trainingDay{:};
            strLeftSideLabel = sprintf('Day: %s \nFixedHold: %d ms \nReactTime: %d ms',trainingDay, input.fixedReqHoldTimeMs, ...
                input.reactTimeMs);
            text(0.0, 0.75, strLeftSideLabel, 'VerticalAlignment', 'top','HorizontalAlignment', 'left');
         
            subplot(row_col{:},nColumns*(j-1)+2)
            hold on
            histogram(arrHitHoldTimes, 'BinWidth',binWidth, 'FaceAlpha',0.5, 'EdgeAlpha', 0.5, 'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
            histogram(arrFaHoldTimes, 'BinWidth',binWidth, 'FaceAlpha',0.5, 'EdgeAlpha', 0.5, 'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
            xlim([0 xMax])
            ylim([0 yMax])
            grid on
            if j==1
                title('Hold times');
            end
            legend('Hit','FA')
            if j==length(arrDays)
                xlabel('Hold Time (ms)')
            end
            ylabel('# of trials')            

            arrHitReactTimes = arrReactTimes(hitInds);
            arrMissReactTimes = arrReactTimes(missInds);
            arrFaReactTimes = arrReactTimes(faInds);

            subplot(row_col{:},nColumns*(j-1)+3)
            hold on
            histogram(arrHitReactTimes, 'BinWidth',widerBinWidth, 'FaceAlpha',0.5, 'EdgeAlpha', 0.5, 'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
            histogram(arrFaReactTimes, 'BinWidth',widerBinWidth, 'FaceAlpha',0.5, 'EdgeAlpha', 0.5, 'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
            grid on
            xlim([xMinReact xMaxReact])
            ylim([0 yMax])
            if j==1
                title('React times');
            end
            legend('Hit','FA')
            if j==length(arrDays)
                xlabel('React Time (ms)')
            end
            ylabel('# of trials')
                        
            bigTitle = sprintf('Mouse: %s%s',globalMiceIdPrefix,mouseId);
            suptitle(bigTitle)
        end
        saveas(fig, strcat(sprintf('out\Mouse%s%s_DailyProgress',globalMiceIdPrefix,mouseId), '.png'));
        
end