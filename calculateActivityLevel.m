function actLvl = calculateActivityLevel(featureTable)
    trainedModel = load('activityLevel_trainedModel.mat');
    [yfit, ~] = trainedModel.trainedModel.predictFcn(featureTable);
    actLvl = yfit;
end