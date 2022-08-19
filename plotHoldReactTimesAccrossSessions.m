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
                plotDetailsForHoldReactTimesAccrossSessions(globalMiceIdPrefix, mouseId, dailyHoldTimes, dailyReactTimes, globalFixedHold, fixedHold)
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
            plotDetailsForHoldReactTimesAccrossSessions(globalMiceIdPrefix, mouseId, dailyHoldTimes,dailyReactTimes, globalFixedHold, fixedHold)
    end
    
end