close all; clear;
% Load training data, test data files
sensorLog_Train = load('datasets/MATLAB Mobile Data/sensorlog_20241210_121705.mat');
sensorLog_Test = load('datasets/MATLAB Mobile Data/sensorlog_20241210_141135.mat');

%% Data Extraction and Preprocessing
% Extract the data from the loaded training file
accelData_Train = sensorLog_Train.Acceleration;
angVelData_Train = sensorLog_Train.AngularVelocity;
magFieldData_Train = sensorLog_Train.MagneticField;
orientationData_Train = sensorLog_Train.Orientation;
positionData_Train = sensorLog_Train.Position;

% Extract the data from the loaded test file
accelData_Test = sensorLog_Test.Acceleration;
angVelData_Test = sensorLog_Test.AngularVelocity;
magFieldData_Test = sensorLog_Test.MagneticField;
orientationData_Test = sensorLog_Test.Orientation;
positionData_Test = sensorLog_Test.Position;

% Find the first timepoint from all timetables
startTime_Train = min([accelData_Train.Timestamp(1), angVelData_Train.Timestamp(1), magFieldData_Train.Timestamp(1), orientationData_Train.Timestamp(1), positionData_Train.Timestamp(1)]);
startTime_Test = min([accelData_Test.Timestamp(1), angVelData_Test.Timestamp(1), magFieldData_Test.Timestamp(1), orientationData_Test.Timestamp(1), positionData_Test.Timestamp(1)]);

% Create time matrices starting from zero
accelTime_Train = seconds(accelData_Train.Timestamp - startTime_Train);
angVelTime_Train = seconds(angVelData_Train.Timestamp - startTime_Train);
magFieldTime_Train = seconds(magFieldData_Train.Timestamp - startTime_Train);
orientationTime_Train = seconds(orientationData_Train.Timestamp - startTime_Train);
positionTime_Train = seconds(positionData_Train.Timestamp - startTime_Train);

accelTime_Test = seconds(accelData_Test.Timestamp - startTime_Test);
angVelTime_Test = seconds(angVelData_Test.Timestamp - startTime_Test);
magFieldTime_Test = seconds(magFieldData_Test.Timestamp - startTime_Test);
orientationTime_Test = seconds(orientationData_Test.Timestamp - startTime_Test);
positionTime_Test = seconds(positionData_Test.Timestamp - startTime_Test);

% Determine the largest time vector for training and test data
maxTimeLength_Train = max([length(accelTime_Train), length(angVelTime_Train), length(magFieldTime_Train), length(orientationTime_Train), length(positionTime_Train)]);
unifiedTime_Train = linspace(0, max([accelTime_Train(end), angVelTime_Train(end), magFieldTime_Train(end), orientationTime_Train(end), positionTime_Train(end)]), maxTimeLength_Train)';

maxTimeLength_Test = max([length(accelTime_Test), length(angVelTime_Test), length(magFieldTime_Test), length(orientationTime_Test), length(positionTime_Test)]);
unifiedTime_Test = linspace(0, max([accelTime_Test(end), angVelTime_Test(end), magFieldTime_Test(end), orientationTime_Test(end), positionTime_Test(end)]), maxTimeLength_Test)';

%% Feature Extraction and Preparing for Classification
% Calculate the magnitude of the acceleration
accelMagnitude_Train = sqrt(accelData_Train.X.^2 + accelData_Train.Y.^2 + accelData_Train.Z.^2);
accelMagnitude_Test = sqrt(accelData_Test.X.^2 + accelData_Test.Y.^2 + accelData_Test.Z.^2);

% Calculate the magnitude of the angular velocity
angVelMagnitude_Train = sqrt(angVelData_Train.X.^2 + angVelData_Train.Y.^2 + angVelData_Train.Z.^2);
angVelMagnitude_Test = sqrt(angVelData_Test.X.^2 + angVelData_Test.Y.^2 + angVelData_Test.Z.^2);

% Extract speed from position data (1 Hz data)
gpsTime_Train = seconds(positionData_Train.Timestamp - startTime_Train);  % Time of GPS data
gpsSpeed_Train = interp1(gpsTime_Train, positionData_Train.speed, accelTime_Train, 'nearest');  % Use 'nearest' for 1 Hz data

gpsTime_Test = seconds(positionData_Test.Timestamp - startTime_Test);  % Time of GPS data
gpsSpeed_Test = interp1(gpsTime_Test, positionData_Test.speed, accelTime_Test, 'nearest');  % Use 'nearest' for 1 Hz data

% Use raw orientation data as features
orientationX_Train = orientationData_Train.X;
orientationY_Train = orientationData_Train.Y;
orientationZ_Train = orientationData_Train.Z;

orientationX_Test = orientationData_Test.X;
orientationY_Test = orientationData_Test.Y;
orientationZ_Test = orientationData_Test.Z;

% Ensure all arrays have the same length by padding with the last value
maxLength_Train = max([length(accelTime_Train), length(angVelTime_Train), length(magFieldTime_Train), length(orientationTime_Train)]);
maxLength_Test = max([length(accelTime_Test), length(angVelTime_Test), length(magFieldTime_Test), length(orientationTime_Test)]);

% Manually pad the data to the same length
accelMagnitude_Train(end+1:maxLength_Train) = accelMagnitude_Train(end); % Repeat last value
angVelMagnitude_Train(end+1:maxLength_Train) = angVelMagnitude_Train(end); % Repeat last value
orientationX_Train(end+1:maxLength_Train) = orientationX_Train(end); % Repeat last value
orientationY_Train(end+1:maxLength_Train) = orientationY_Train(end); % Repeat last value
orientationZ_Train(end+1:maxLength_Train) = orientationZ_Train(end); % Repeat last value
gpsSpeed_Train(end+1:maxLength_Train) = gpsSpeed_Train(end); % Repeat last value

accelMagnitude_Test(end+1:maxLength_Test) = accelMagnitude_Test(end); % Repeat last value
angVelMagnitude_Test(end+1:maxLength_Test) = angVelMagnitude_Test(end); % Repeat last value
orientationX_Test(end+1:maxLength_Test) = orientationX_Test(end); % Repeat last value
orientationY_Test(end+1:maxLength_Test) = orientationY_Test(end); % Repeat last value
orientationZ_Test(end+1:maxLength_Test) = orientationZ_Test(end); % Repeat last value
gpsSpeed_Test(end+1:maxLength_Test) = gpsSpeed_Test(end); % Repeat last value

% Pad the time vectors to the same length
accelTime_Train(end+1:maxLength_Train) = accelTime_Train(end);
angVelTime_Train(end+1:maxLength_Train) = angVelTime_Train(end);
positionTime_Train(end+1:maxLength_Train) = positionTime_Train(end);
orientationTime_Train(end+1:maxLength_Train) = orientationTime_Train(end);

accelTime_Test(end+1:maxLength_Test) = accelTime_Test(end);
angVelTime_Test(end+1:maxLength_Test) = angVelTime_Test(end);
positionTime_Test(end+1:maxLength_Test) = positionTime_Test(end);
orientationTime_Test(end+1:maxLength_Test) = orientationTime_Test(end);

% Debug statements to display sizes of features
disp(['Size of accelMagnitude_Train: ', num2str(length(accelMagnitude_Train))]);
disp(['Size of angVelMagnitude_Train: ', num2str(length(angVelMagnitude_Train))]);
disp(['Size of gpsSpeed_Train: ', num2str(length(gpsSpeed_Train))]);
disp(['Size of orientationX_Train: ', num2str(length(orientationX_Train))]);
disp(['Size of orientationY_Train: ', num2str(length(orientationY_Train))]);
disp(['Size of orientationZ_Train: ', num2str(length(orientationZ_Train))]);

disp(['Size of accelMagnitude_Test: ', num2str(length(accelMagnitude_Test))]);
disp(['Size of angVelMagnitude_Test: ', num2str(length(angVelMagnitude_Test))]);
disp(['Size of gpsSpeed_Test: ', num2str(length(gpsSpeed_Test))]);
disp(['Size of orientationX_Test: ', num2str(length(orientationX_Test))]);
disp(['Size of orientationY_Test: ', num2str(length(orientationY_Test))]);
disp(['Size of orientationZ_Test: ', num2str(length(orientationZ_Test))]);

% Create the feature table for training data
features_Train = table(accelMagnitude_Train, angVelMagnitude_Train, gpsSpeed_Train, orientationX_Train, orientationY_Train, orientationZ_Train);

%% MANUALLY LABEL DATA
labels_Train = zeros(maxLength_Train, 1);

for i = 1:maxLength_Train
    if accelTime_Train(i) <= 47.5
        labels_Train(i) = 1; % Light activity
    elseif accelTime_Train(i) <= 58.16
        labels_Train(i) = 0; % No activity
    elseif accelTime_Train(i) <= 110
        labels_Train(i) = 2; % Moderate activity
    elseif accelTime_Train(i) <= 132.5
        labels_Train(i) = 3; % Intense activity
    else
        labels_Train(i) = 1; % Light activity
    end
end

labels_Test = zeros(maxLength_Test, 1);
for i = 1:maxLength_Test
    if accelTime_Test(i) <= 30
        labels_Test(i) = 1; % Light activity
    elseif accelTime_Test(i) <= 36.8
        labels_Test(i) = 0; % No activity
    elseif accelTime_Test(i) <= 50
        labels_Test(i) = 2; % Moderate activity
    elseif accelTime_Test(i) <= 62.5
        labels_Test(i) = 1; % Light activity
    elseif accelTime_Test(i) <= 68
        labels_Test(i) = 0; % No activity
    elseif accelTime_Test(i) <= 76
        labels_Test(i) = 3; % Intense activity
    elseif accelTime_Test(i) <= 106
        labels_Test(i) = 2; % Moderate activity
    else 
        labels_Test(i) = 1; % No activity
    end
end

%% Pack data and open classification learner
% Add the labels as a column to the feature table for training data
featuresWithLabels_Train = [features_Train table(labels_Train)];

% Ensure your table is correctly formatted
featuresWithLabels_Train.Properties.VariableNames = {'accelMagnitude', 'angVelMagnitude', 'speed', 'orientationX', 'orientationY', 'orientationZ', 'activityLevel'};

% Create the feature table for test data
features_Test = table(accelMagnitude_Test, angVelMagnitude_Test, gpsSpeed_Test, orientationX_Test, orientationY_Test, orientationZ_Test);

% Add the labels as a column to the feature table for test data
featuresWithLabels_Test = [features_Test table(labels_Test)];

% Ensure your table is correctly formatted
featuresWithLabels_Test.Properties.VariableNames = {'accelMagnitude', 'angVelMagnitude', 'speed', 'orientationX', 'orientationY', 'orientationZ', 'activityLevel'};

% Open the Classification Learner app
classificationLearner

%% Plotting the Features and Labels Against Time for Training Data
figure('WindowState', 'maximized');
sgtitle('Training Data Features and Activity Level Over Time');
subplot(7, 1, 1);
plot(unifiedTime_Train, featuresWithLabels_Train.accelMagnitude, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Accel Magnitude');
title('Acceleration Magnitude Over Time (Train)');
grid on;

subplot(7, 1, 2);
plot(unifiedTime_Train, featuresWithLabels_Train.angVelMagnitude, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Ang Vel Magnitude');
title('Angular Velocity Magnitude Over Time (Train)');
grid on;

subplot(7, 1, 3);
plot(unifiedTime_Train, featuresWithLabels_Train.speed, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Speed (m/s)');
title('Speed Over Time (Train)');
grid on;

subplot(7, 1, 4);
plot(unifiedTime_Train, featuresWithLabels_Train.orientationX, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Orientation X (degrees)');
title('Orientation X Over Time (Train)');
grid on;

subplot(7, 1, 5);
plot(unifiedTime_Train, featuresWithLabels_Train.orientationY, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Orientation Y (degrees)');
title('Orientation Y Over Time (Train)');
grid on;

subplot(7, 1, 6);
plot(unifiedTime_Train, featuresWithLabels_Train.orientationZ, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Orientation Z (degrees)');
title('Orientation Z Over Time (Train)');
grid on;

subplot(7, 1, 7);
plot(unifiedTime_Train, featuresWithLabels_Train.activityLevel, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Activity Level');
title('Activity Level Over Time (Train)');
yticks([0 1 2 3]);
yticklabels({'No Activity', 'Light', 'Moderate', 'Intense'});
grid on;


%% Plotting the Features and Labels Against Time for Test Data
figure('WindowState', 'maximized');
sgtitle('Test Data Features and Activity Level Over Time');
subplot(7, 1, 1);
plot(unifiedTime_Test, featuresWithLabels_Test.accelMagnitude, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Accel Magnitude');
title('Acceleration Magnitude Over Time (Test)');
grid on;

subplot(7, 1, 2);
plot(unifiedTime_Test, featuresWithLabels_Test.angVelMagnitude, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Ang Vel Magnitude');
title('Angular Velocity Magnitude Over Time (Test)');
grid on;

subplot(7, 1, 3);
plot(unifiedTime_Test, featuresWithLabels_Test.speed, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Speed (m/s)');
title('Speed Over Time (Test)');
grid on;

subplot(7, 1, 4);
plot(unifiedTime_Test, featuresWithLabels_Test.orientationX, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Orientation X (degrees)');
title('Orientation X Over Time (Test)');
grid on;

subplot(7, 1, 5);
plot(unifiedTime_Test, featuresWithLabels_Test.orientationY, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Orientation Y (degrees)');
title('Orientation Y Over Time (Test)');
grid on;

subplot(7, 1, 6);
plot(unifiedTime_Test, featuresWithLabels_Test.orientationZ, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Orientation Z (degrees)');
title('Orientation Z Over Time (Test)');
grid on;

subplot(7, 1, 7);
plot(unifiedTime_Test, featuresWithLabels_Test.activityLevel, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Activity Level');
title('Activity Level Over Time (Test)');
yticks([0 1 2 3]);
yticklabels({'No Activity', 'Light', 'Moderate', 'Intense'});
grid on;

%% Save the feature tables as .mat files
save('datasets/actLvl_trainingDataLabeled.mat', 'featuresWithLabels_Train');
save('datasets/actLvl_testDataLabeled.mat', 'featuresWithLabels_Test');

