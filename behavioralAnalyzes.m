
clc
clear all
close all

globalMiceIdPrefix = '28';
mouseIds = {'03', '04', '05','06','07'};

dataPath = 'D:\GoogleDrive\postDoc\hullLab\MWorks_LabJack\MWorksCodesOnTheRig2\dataToAnalyze\';
name = 'Hold and Detect Constant Behavioral Analyzes';

for a=1:length(mouseIds)
        mouseId = mouseIds(a);
        mouseId = mouseId{:};
        dataFile = ['data-i' globalMiceIdPrefix mouseId '-*.mat'];
        
        dirStruct = dir([dataPath dataFile]);
        %S = S(~[S.isdir]);
        [~,arrDays] = sort([dirStruct.datenum]);

        plotDailyHoldReactPDFs(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath);        
        plotDailyMeanHoldReactTimes(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath);        
        plotDailyBehavioralOutcomeCounts(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath);
        plotDailyHoldReactCDFs(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath);
        plotHoldReactTimesAccrossSessions(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath);
        plotHoldReactTimesEachDay(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath);
        plotHitHoldReactTimesEachDay(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath);
        %plotDailyQuadraturePosition(arrDays, globalMiceIdPrefix, mouseId, dirStruct, dataPath)
        close all
end

plotHoldReactTimesEachDayAllMice(globalMiceIdPrefix, mouseIds, dataPath)