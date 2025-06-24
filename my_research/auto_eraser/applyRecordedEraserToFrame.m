function outputFrame = applyRecordedEraserToFrame(inputFrame, recordedMovements)
% APPLYRECORDEDERASERTOFRAME Applies a series of recorded erase operations
% to a given image frame.
%
%   outputFrame = applyRecordedEraserToFrame(inputFrame, recordedMovements)
%
%   Inputs:
%     inputFrame      - The image frame (e.g., from a video, or another image)
%                       to which the recorded erasures will be applied.
%     recordedMovements - An N x 3 matrix where each row is [x_coord, y_coord, brush_radius]
%                       representing a single erase point. This is the output
%                       of interactiveEraserToolWithBrushSizeAndRecording.
%
%   Output:
%     outputFrame     - The inputFrame with the recorded erase operations applied.

    if isempty(recordedMovements)
        fprintf('No recorded movements to apply. Returning original frame.\n');
        outputFrame = inputFrame;
        return;
    end

    fprintf('Applying %d recorded erase operations to the frame...\n', size(recordedMovements, 1));

    % Make a copy of the input frame to modify
    % Ensure it's logical for consistent 0/1 binary operations.
    if ~islogical(inputFrame)
        currentFrame = imbinarize(inputFrame);
    else
        currentFrame = inputFrame;
    end

    [rows, cols] = size(currentFrame);

    % Iterate through each recorded erase movement
    for i = 1:size(recordedMovements, 1)
        centerX = recordedMovements(i, 1);
        centerY = recordedMovements(i, 2);
        brushRad = recordedMovements(i, 3);

        % Define the bounding box for the circular brush area
        xMin = max(1, centerX - brushRad);
        xMax = min(cols, centerX + brushRad);
        yMin = max(1, centerY - brushRad);
        yMax = min(rows, centerY + brushRad);

        % Iterate over pixels within the bounding box and apply erase
        for r = yMin:yMax
            for c = xMin:xMax
                % Check if the current pixel is within the circular brush radius
                if (c - centerX)^2 + (r - centerY)^2 <= brushRad^2
                    currentFrame(r, c) = 0; % Set to black (erased)
                end
            end
        end
    end

    outputFrame = currentFrame;
    fprintf('Erase operations applied successfully.\n');
end