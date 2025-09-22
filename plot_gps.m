% Clear workspace and load data
clear;
load('sensorlog4prokt.mat');

% Extract GPS data
lat = Position.latitude; % Latitude
lon = Position.longitude; % Longitude
positionDatetime = Position.Timestamp; % Timestamps for position

% Plot route visualization
figure;
geoplot(lat, lon, '-o'); % Requires Mapping Toolbox
title('Route Visualization');
grid on;

