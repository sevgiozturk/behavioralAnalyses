function plotDailyHoldReactPDFs(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath) 

    binWidth = 50;
    f = figure('Name', [globalMiceIdPrefix mouseId]);
    set(f, 'Position', [1500 50 800 400]);
    hold on
    
%     arrTrainingDays = [];
    for j=1:length(arrDays)
            fileName = dirStruct(arrDays(j)).name;
            fullFilename = [dataPath fileName];
            data = load(fullFilename);
            input = data.input;
            
%             trainingDay =  extractBetween(fileName,[globalMiceIdPrefix mouseId '-'],'-');
%             trainingDay = trainingDay{:};
%             arrTrainingDays = [arrTrainingDays; trainingDay];
            
            xMax = input.fixedReqHoldTimeMs+2000;
            arrHoldTimes = cell2mat(input.holdTimesMs);
            arrReactTimes = cell2mat(input.reactTimesMs);
            arrHoldTimes = arrHoldTimes(arrHoldTimes<5000); % exclude outliers
            arrReactTimes = arrReactTimes(arrReactTimes<5000); % exclude outliers
            
            ax1 = subplot(1,2,1);
            hold on
            %yyaxis left
            %histogram(arrHoldTimes, 'BinWidth',binWidth, 'FaceAlpha',0.5, 'EdgeAlpha', 0.5); %, 'FaceColor',[1 1 1],'EdgeColor',[0 0 1])
            
            pd = fitdist(arrHoldTimes','Normal');
            sortedHoldTimes = sort(arrHoldTimes);
            xVals = double(sortedHoldTimes'); % pdf function acting up with integer values!
            pdfFunction = pdf(pd,xVals);
            %yyaxis right
            plot(xVals, pdfFunction, 'LineWidth',2);
            grid on;
            title('Hold Time PDF')
            xlabel('')
            xlim([0 xMax]);
            
            ax2 = subplot(1,2,2);
            hold on
            %yyaxis left
            %histogram(arrReactTimes, 'BinWidth',binWidth, 'FaceAlpha',0.5, 'EdgeAlpha', 0.5);
            
            pd = fitdist(arrReactTimes','Normal');
            sortedReactTimes = sort(arrReactTimes);
            xVals = double(sortedReactTimes'); % pdf function acting up with integer values!
            pdfFunction = pdf(pd,xVals);
            %yyaxis right
            plot(xVals, pdfFunction, 'LineWidth',2);
            grid on;
            title('Reaction Time PDF')          
            xlabel('')
            xlim([-1*(input.fixedReqHoldTimeMs+500) 5000]);
    end
    
    legend(ax1,string(arrDays)); %arrTrainingDays));
    legend(ax2,string(arrDays)); %arrTrainingDays));
    bigTitle = sprintf('Mouse: %s%s',globalMiceIdPrefix,mouseId);
    suptitle(bigTitle)
    
    % Give common xlabel, ylabel and title to your figure
    han=axes(f,'visible','off'); 
    han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    ylabel(han,'');
    xlabel(han,'Time (ms)');
    saveas(f, strcat(sprintf('out/Mouse%s%s_DailyProgressPDFs',globalMiceIdPrefix,mouseId), '.png'));
end