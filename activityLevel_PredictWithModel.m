trainedModel = load('activityLevel_trainedModel.mat');
testData = load('datasets\actLvl_testDataLabeled.mat');
% Extract features and labels
testFeatures = testData.featuresWithLabels_Test(:, 1:6);
testLabels = testData.featuresWithLabels_Test(:, 7);

accelData_Test = sensorLog_Test.Acceleration;
angVelData_Test = sensorLog_Test.AngularVelocity;
magFieldData_Test = sensorLog_Test.MagneticField;
orientationData_Test = sensorLog_Test.Orientation;
positionData_Test = sensorLog_Test.Position;

startTime_Test = min([accelData_Test.Timestamp(1), angVelData_Test.Timestamp(1), magFieldData_Test.Timestamp(1), orientationData_Test.Timestamp(1), positionData_Test.Timestamp(1)]);

accelTime_Test = seconds(accelData_Test.Timestamp - startTime_Test);
angVelTime_Test = seconds(angVelData_Test.Timestamp - startTime_Test);
magFieldTime_Test = seconds(magFieldData_Test.Timestamp - startTime_Test);
orientationTime_Test = seconds(orientationData_Test.Timestamp - startTime_Test);
positionTime_Test = seconds(positionData_Test.Timestamp - startTime_Test);

maxTimeLength_Test = max([length(accelTime_Test), length(angVelTime_Test), length(magFieldTime_Test), length(orientationTime_Test), length(positionTime_Test)]);
unifiedTime_Test = linspace(0, max([accelTime_Test(end), angVelTime_Test(end), magFieldTime_Test(end), orientationTime_Test(end), positionTime_Test(end)]), maxTimeLength_Test)';

[yfit, scores] = trainedModel.trainedModel.predictFcn(testFeatures);

figure('WindowState', 'maximized');

subplot(2, 1, 1);
plot(unifiedTime_Test, actualLabels, 'b', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Activity Level');
title('Actual Activity Level Over Time');
yticks([0 1 2 3]);
yticklabels({'No Activity', 'Light', 'Moderate', 'Intense'});
grid on;

subplot(2, 1, 2);
plot(unifiedTime_Test, yfit, 'r', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Activity Level');
title('Predicted Activity Level Over Time');
yticks([0 1 2 3]);
yticklabels({'No Activity', 'Light', 'Moderate', 'Intense'});
grid on;