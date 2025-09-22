function stepsTaken = calculateSteps(Xacc, Yacc, Zacc)
    % Calculate acceleration magnitude
    accelerationMagnitude = sqrt(Xacc.^2 + Yacc.^2 + Zacc.^2);

    % Smooth the acceleration signal using a moving average filter
    windowSize = 5; % Adjust based on data sampling rate
    filteredAccel = movmean(accelerationMagnitude, windowSize);

    % Detect peaks in the filtered signal
    [peaks, ~] = findpeaks(filteredAccel, 'MinPeakHeight', 1.2, 'MinPeakDistance', 20);

    % Count steps
    stepsTaken = length(peaks);
end
