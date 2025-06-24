% MATLAB code to draw a quadratic Bezier curve and adjust its curvature
% using two endpoints and one control point.

% Clear workspace and close all figures
clear;
close all;
clc;

% --- 1. Define the points ---
% P1: First endpoint (start of the curve)
P1 = [1, 2];

% P2: Second endpoint (end of the curve)
P2 = [7, 3];

% P3: Control point (adjusts the curvature)
% Try changing this point to see how the curve changes!
P3 = [2, 0]; % Changed: New example control point to adjust curvature

% Display the defined points
fprintf('Point P1 (Endpoint 1): [%.2f, %.2f]\n', P1(1), P1(2));
fprintf('Point P2 (Endpoint 2): [%.2f, %.2f]\n', P2(1), P2(2));
fprintf('Point P3 (Control Point): [%.2f, %.2f]\n', P3(1), P3(2));

% --- 2. Generate points along the Bezier curve ---
% Number of points to generate for the curve (higher for smoother curve)
numPoints = 100;
t = linspace(0, 1, numPoints); % Parameter 't' from 0 to 1

% Initialize arrays to store x and y coordinates of the curve points
curveX = zeros(1, numPoints);
curveY = zeros(1, numPoints);

% Calculate points using the quadratic Bezier curve formula:
% B(t) = (1-t)^2 * P1 + 2*(1-t)*t * P3 + t^2 * P2
for i = 1:numPoints
    current_t = t(i);
    
    % X-coordinate of the current point on the curve
    curveX(i) = (1 - current_t)^2 * P1(1) + ...
                2 * (1 - current_t) * current_t * P3(1) + ...
                current_t^2 * P2(1);
            
    % Y-coordinate of the current point on the curve
    curveY(i) = (1 - current_t)^2 * P1(2) + ...
                2 * (1 - current_t) * current_t * P3(2) + ...
                current_t^2 * P2(2);
end

% --- 3. Plotting the curve and control points ---
figure; % Create a new figure window

% Plot the Bezier curve
plot(curveX, curveY, 'b-', 'LineWidth', 2);
hold on; % Keep the plot active to add more elements

% Plot the endpoints
plot(P1(1), P1(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(P1(1) + 0.2, P1(2) + 0.2, 'P1 (Endpoint)');

plot(P2(1), P2(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(P2(1) + 0.2, P2(2) + 0.2, 'P2 (Endpoint)');

% Plot the control point
plot(P3(1), P3(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
text(P3(1) + 0.2, P3(2) + 0.2, 'P3 (Control Point)');

% Plot the guiding lines (P1-P3 and P3-P2)
% Changed line style from dashed ('k--') to solid ('k-') to make them appear more connected
plot([P1(1), P3(1)], [P1(2), P3(2)], 'k-', 'LineWidth', 1);
plot([P3(1), P2(1)], [P3(2), P2(2)], 'k-', 'LineWidth', 1);

% Add labels and title
xlabel('X-axis');
ylabel('Y-axis');
title('Quadratic Bezier Curve');
grid on;
axis equal; % Ensure equal scaling for x and y axes for better visualization
legend('Bezier Curve', 'Endpoints', 'Control Point', 'Guiding Lines', 'Location', 'best');
hold off;

% Instructions for the user:
disp(' ');
disp('-------------------------------------------------------------------');
disp('This plot shows a quadratic Bezier curve.');
disp('The curve is defined by two endpoints (P1, P2) and one control point (P3).');
disp('You can adjust the curvature by changing the coordinates of P3 in the code.');
disp('Run the script again after modifying P3 to see the effect!');
disp('-------------------------------------------------------------------');