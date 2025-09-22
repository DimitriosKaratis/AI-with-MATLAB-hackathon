% Load the data file
sensorlog = load('sensorlog_20241210_121705.mat');

% Extract the data from the loaded file
accelData = sensorlog.Acceleration;
angVelData = sensorlog.AngularVelocity;
magFieldData = sensorlog.MagneticField;
orientationData = sensorlog.Orientation;
positionData = sensorlog.Position;

% Find the first timepoint from all timetables
startTime = min([accelData.Timestamp(1), angVelData.Timestamp(1), magFieldData.Timestamp(1), orientationData.Timestamp(1), positionData.Timestamp(1)]);

% Create time matrices starting from zero
accelTime = seconds(accelData.Timestamp - startTime);
angVelTime = seconds(angVelData.Timestamp - startTime);
magFieldTime = seconds(magFieldData.Timestamp - startTime);
orientationTime = seconds(orientationData.Timestamp - startTime);
positionTime = seconds(positionData.Timestamp - startTime);

% Calculate the magnitude of the acceleration
accelMagnitude = sqrt(accelData.X.^2 + accelData.Y.^2 + accelData.Z.^2);

% Calculate the magnitude of the angular velocity
angVelMagnitude = sqrt(angVelData.X.^2 + angVelData.Y.^2 + angVelData.Z.^2);

% Set parameters for the spectrogram calculation
windowLength = 256; % Length of the window (number of samples)
overlapLength = 128; % Number of overlapping samples

% Compute the spectrogram for each orientation axis (Azimuth, Pitch, and Roll)
[Azimuth_STFT, fAzimuth, tAzimuth] = spectrogram(orientationData.X, windowLength, overlapLength, [], 50);
[Pitch_STFT, fPitch, tPitch] = spectrogram(orientationData.Y, windowLength, overlapLength, [], 50);
[Roll_STFT, fRoll, tRoll] = spectrogram(orientationData.Z, windowLength, overlapLength, [], 50);

% Calculate the magnitude of the spectrogram for each axis
Azimuth_magnitude = abs(Azimuth_STFT);
Pitch_magnitude = abs(Pitch_STFT);
Roll_magnitude = abs(Roll_STFT);

% Align the time vectors (since they may not be the same length)
commonTime = min([length(tAzimuth), length(tPitch), length(tRoll)]); % To handle any potential differences in length

% Calculate the mean of the magnitude for all three orientations at each time point
meanMagnitude = mean([Azimuth_magnitude(1:commonTime, :); Pitch_magnitude(1:commonTime, :); Roll_magnitude(1:commonTime, :)], 1);

% Plot the activity level over time
figure;
subplot(6, 1, 1);
plot(accelTime, activityLevel, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Activity Level');
title('Activity Level Over Time');
yticks([1 2 3]);
yticklabels({'Light', 'Moderate', 'High'});
grid on;

% Plot the acceleration (X, Y, Z) over time
subplot(6, 1, 2);
plot(accelTime, accelData.X, 'r', 'LineWidth', 1.5); hold on;
plot(accelTime, accelData.Y, 'g', 'LineWidth', 1.5);
plot(accelTime, accelData.Z, 'b', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Acceleration (m/s^2)');
title('Acceleration (X, Y, Z) Over Time');
legend('X', 'Y', 'Z');
grid on;

% Plot the gyroscope (X, Y, Z) over time
subplot(6, 1, 3);
plot(angVelTime, angVelData.X, 'r', 'LineWidth', 1.5); hold on;
plot(angVelTime, angVelData.Y, 'g', 'LineWidth', 1.5);
plot(angVelTime, angVelData.Z, 'b', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Angular Velocity (rad/s)');
title('Gyroscope (X, Y, Z) Over Time');
legend('X', 'Y', 'Z');
grid on;

% Plot the position speed over time
subplot(6, 1, 4);
plot(positionTime, positionData.speed, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Speed (m/s)');
title('Position Speed Over Time');
grid on;

% Plot the orientation (X, Y, Z) over time
subplot(6, 1, 5);
plot(orientationTime, orientationData.X, 'r', 'LineWidth', 1.5); hold on;
plot(orientationTime, orientationData.Y, 'g', 'LineWidth', 1.5);
plot(orientationTime, orientationData.Z, 'b', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Orientation (degrees)');
title('Orientation (X, Y, Z) Over Time');
legend('Azimuth', 'Pitch', 'Roll');
grid on;

% Plot the mean magnitude of all orientations over time
subplot(6, 1, 6);
plot(tAzimuth(1:commonTime), meanMagnitude, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Mean Magnitude of Orientation (Azimuth + Pitch + Roll)');
title('Mean Magnitude of All Orientations Over Time');
grid on;
