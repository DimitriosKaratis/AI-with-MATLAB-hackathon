clc;
clear;

data = readtable('dailyActivity_merged.csv');

features = [data.TotalSteps, ...
            data.VeryActiveMinutes, ...
            data.FairlyActiveMinutes, ...
            data.LightlyActiveMinutes]; 
calories = data.Calories;

mean_calories = mean(calories);
std_calories = std(calories);

features = normalize(features);
calories_normalized = (calories - mean_calories) / std_calories;

cv = cvpartition(size(data, 1), 'HoldOut', 0.2);
trainIdx = training(cv);
testIdx = test(cv);

X_train = features(trainIdx, :);
y_train = calories_normalized(trainIdx);
X_test = features(testIdx, :);
y_test = calories_normalized(testIdx);

hiddenLayerSize = [20, 10];
net = fitnet(hiddenLayerSize, 'trainbr');

net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0.1;
net.divideParam.testRatio = 0.1;

[net, tr] = train(net, X_train', y_train');

y_pred_nn = net(X_test');
y_pred_nn = y_pred_nn';

y_test_denorm = y_test * std_calories + mean_calories;
y_pred_nn_denorm = y_pred_nn * std_calories + mean_calories;

mse_nn = mean((y_test - y_pred_nn).^2);
ss_total_nn = sum((y_test - mean(y_test)).^2);
ss_residual_nn = sum((y_test - y_pred_nn).^2);
r2_nn = 1 - (ss_residual_nn / ss_total_nn);

disp(['Neural Network Mean Squared Error on Test Set (normalized): ', num2str(mse_nn)]);
disp(['Neural Network R-squared on Test Set (normalized): ', num2str(r2_nn)]);

absoluteErrors = abs(y_test_denorm - y_pred_nn_denorm);
mae_nn = mean(absoluteErrors);
rmse_nn = sqrt(mean((y_test_denorm - y_pred_nn_denorm).^2));

adjusted_y_test_denorm = max(abs(y_test_denorm), 1e-6);
mape = mean(absoluteErrors ./ adjusted_y_test_denorm) * 100;
range = max(y_test_denorm) - min(y_test_denorm);
rangeBasedAccuracy = 100 - (mean(absoluteErrors) / range) * 100;

disp(['Neural Network Mean Absolute Error (MAE): ', num2str(mae_nn)]);
disp(['Neural Network Root Mean Squared Error (RMSE): ', num2str(rmse_nn)]);
disp(['Neural Network Range-Based Percentage Accuracy: ', num2str(rangeBasedAccuracy), '%']);

figure;
scatter(y_test_denorm, y_pred_nn_denorm, 'filled');
xlabel('Actual Calories');
ylabel('Predicted Calories');
title('Neural Network: Actual vs Predicted Calories (Denormalized)');
grid on;

figure;
plotperform(tr);
title('Fine-Tuned Neural Network Training Performance');

meanActivityMinutes = mean(features(:, 2:4), 1); 

nFeatures = size(X_train, 2);
base_mse = mean((y_test_denorm - y_pred_nn_denorm).^2);
featureImportance = zeros(1, nFeatures);

for i = 1:nFeatures
    X_test_permuted = X_test;
    X_test_permuted(:, i) = X_test(randperm(size(X_test, 1)), i);
    y_pred_permuted = net(X_test_permuted');
    y_pred_permuted = y_pred_permuted' * std_calories + mean_calories;
    mse_permuted = mean((y_test_denorm - y_pred_permuted).^2);
    featureImportance(i) = mse_permuted - base_mse;
end

featureImportance = featureImportance / sum(featureImportance);

figure;
bar(featureImportance);
xticklabels({'TotalSteps', ...
             'VeryActiveMinutes', 'FairlyActiveMinutes', ...
             'LightlyActiveMinutes'});
xtickangle(45);
ylabel('Normalized Feature Importance (Raw)');
title('Raw Feature Importance');