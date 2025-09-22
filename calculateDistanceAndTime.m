function [totalDistance, totalTimeSeconds] = calculateDistanceAndTime(gpsData)
    % Extract GPS data
    lat = gpsData.latitude; % Latitude
    lon = gpsData.longitude; % Longitude
    positionDatetime = gpsData.Timestamp; % Timestamps for position

    % Convert timestamps to elapsed time (seconds)
    positionTime = timeElapsed(positionDatetime);

    % Initialize variables
    totalDistance = 0; % Total distance traveled in miles

    % Loop through GPS data to calculate total distance traveled
    for i = 1:(length(lat) - 1)
        lat1 = lat(i); lat2 = lat(i + 1);
        lon1 = lon(i); lon2 = lon(i + 1);

        % Calculate distance between two points using Haversine formula
        distanceMiles = haversine(lat1, lon1, lat2, lon2);
        totalDistance = totalDistance + distanceMiles;
    end

    % Convert total distance to kilometers
    totalDistance = totalDistance * 1.60934;

    % Calculate total time for the activity in seconds
    totalTimeSeconds = positionTime(end) - positionTime(1);
end

% Haversine Function
function distMiles = haversine(lat1, lon1, lat2, lon2)
    % Convert degrees to radians
    lat1 = deg2rad(lat1);
    lon1 = deg2rad(lon1);
    lat2 = deg2rad(lat2);
    lon2 = deg2rad(lon2);

    % Earth's radius in miles
    earthRadius = 3958.8;

    dlat = lat2 - lat1;
    dlon = lon2 - lon1;
    a = sin(dlat/2).^2 + cos(lat1) .* cos(lat2) .* sin(dlon/2).^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    distMiles = earthRadius * c;
end

% Helper Function: Convert datetime to elapsed time (seconds)
function elapsedTime = timeElapsed(datetimeArray)
    elapsedTime = seconds(datetimeArray - datetimeArray(1));
end