function recordedMovements = interactiveEraserToolWithBrushSizeAndRecording()
% INTERACTIVEERASERTOOLWITHBRUSHSIZEANDRECORDING An interactive eraser tool
% that records all erase operations for later playback.
%   Move your mouse over the image to see the brush outline.
%   Click and drag to erase (set pixels to black).
%   Press 'S' to save the current modified image.
%   Press 'R' to reset the image to its original state.
%   Close the figure to return the recorded movements.

    % --- Configuration ---
    imageFilePath = 'frame_0_bin.jpg'; % <<< IMPORTANT: Change this to your image file path
    eraserBrushRadius = 30; % Radius of the eraser brush in pixels
    brushColor = 'r'; % Color of the brush outline (e.g., 'r' for red, 'b' for blue)
    brushLineWidth = 2; % Line width of the brush outline

    % Initialize storage for recorded movements: [x_coord, y_coord, brush_radius]
    recordedMovements = zeros(0, 3); % Start as an empty N x 3 matrix

    % --- 1. Load the Image ---
    try
        originalImage = imread(imageFilePath);
    catch
        warning('Image "%s" not found. Creating a random binary image for demonstration.', imageFilePath);
        originalImage = imbinarize(rand(400, 600) > 0.5);
    end

    % Ensure the image is logical (0s and 1s) for consistent erasing.
    if ~islogical(originalImage)
        currentImage = imbinarize(originalImage);
    else
        currentImage = originalImage;
    end

    % --- 2. Setup the Figure and Axes ---
    hFig = figure('Name', 'Eraser Tool (Recording Mode)', 'NumberTitle', 'off', ...
                  'toolbar', 'none', 'menubar', 'none');
    hAx = axes('Parent', hFig, 'Units', 'normalized', 'Position', [0 0 1 1]);
    hIm = imshow(currentImage, 'Parent', hAx);
    title(hAx, 'Move Mouse to See Brush | Click & Drag to Erase | S: Save | R: Reset | Close to Finish Recording');

    % --- 3. Create the Brush Visualization Object ---
    theta = linspace(0, 2*pi, 100); % Points for a smooth circle
    hBrushCircle = line('Parent', hAx, 'XData', [], 'YData', [], ...
                        'Color', brushColor, 'LineWidth', brushLineWidth, ...
                        'Visible', 'off');

    % --- 4. Store Data for Callbacks ---
    set(hFig, 'UserData', struct(...
        'imageHandle', hIm, ...
        'brushHandle', hBrushCircle, ...
        'brushRadius', eraserBrushRadius, ...
        'isErasing', false, ...
        'originalImage', originalImage, ...
        'recordedMovements', recordedMovements)); % Store the recording array

    % --- 5. Set up Mouse and Keyboard Callbacks ---
    set(hFig, 'WindowButtonDownFcn', @mouseDownCallback);
    set(hFig, 'WindowButtonMotionFcn', @mouseMotionCallback);
    set(hFig, 'WindowButtonUpFcn', @mouseUpCallback);
    set(hFig, 'KeyPressFcn', @keyPressCallback);
    set(hFig, 'CloseRequestFcn', @figureCloseCallback); % Capture figure close event

    fprintf('Recording eraser tool started.\n');
    fprintf('1. Move your mouse over the image to see the brush size.\n');
    fprintf('2. Click and drag the mouse to erase (turn white pixels black).\n');
    fprintf('3. Press the ''S'' key on your keyboard to save the modified image during recording.\n');
    fprintf('4. Press the ''R'' key on your keyboard to reset the image to its original state.\n');
    fprintf('5. Close the figure window to finish recording and retrieve the movements.\n');

    % Wait until the figure is closed by the user
    uiwait(hFig);
    
    % Retrieve the final recorded movements when the figure is closed
    if isvalid(hFig) % Check if figure still exists (wasn't deleted by force)
        udata = get(hFig, 'UserData');
        recordedMovements = udata.recordedMovements;
        delete(hFig); % Close figure if it wasn't closed by close request
    else
        recordedMovements = zeros(0, 3); % Return empty if figure was force-closed or error
    end

    % --- Callback Functions ---

    function mouseDownCallback(src, ~)
        udata = get(src, 'UserData');
        udata.isErasing = true;
        set(src, 'UserData', udata);
        erasePixelsAndRecord(src); % Perform initial erase and record
    end

    function mouseMotionCallback(src, ~)
        udata = get(src, 'UserData');
        hBrush = udata.brushHandle;

        currentPoint = get(hAx, 'CurrentPoint');
        centerX = currentPoint(1,1);
        centerY = currentPoint(1,2);

        set(hBrush, 'XData', centerX + udata.brushRadius * cos(theta), ...
                    'YData', centerY + udata.brushRadius * sin(theta), ...
                    'Visible', 'on');

        if udata.isErasing
            erasePixelsAndRecord(src); % Erase and record continuously while dragging
        end
        drawnow limitrate;
    end

    function mouseUpCallback(src, ~)
        udata = get(src, 'UserData');
        udata.isErasing = false;
        set(src, 'UserData', udata);
        % Keep brush visible after mouse up for better user experience
    end

    function erasePixelsAndRecord(figHandle)
        % Core function to modify image pixels AND record the operation
        udata = get(figHandle, 'UserData');
        hIm = udata.imageHandle;
        brushRad = udata.brushRadius;

        currentPoint = get(hAx, 'CurrentPoint');
        centerX = round(currentPoint(1,1));
        centerY = round(currentPoint(1,2));

        % --- Record the current erase point ---
        udata.recordedMovements(end+1, :) = [centerX, centerY, brushRad];
        set(figHandle, 'UserData', udata); % Update UserData with new recorded movement

        % --- Perform the actual pixel erasure ---
        modifiedImage = get(hIm, 'CData');
        [rows, cols] = size(modifiedImage);

        xMin = max(1, centerX - brushRad);
        xMax = min(cols, centerX + brushRad);
        yMin = max(1, centerY - brushRad);
        yMax = min(rows, centerY + brushRad);

        for r = yMin:yMax
            for c = xMin:xMax
                if (c - centerX)^2 + (r - centerY)^2 <= brushRad^2
                    modifiedImage(r, c) = 0; % Set to black
                end
            end
        end
        set(hIm, 'CData', modifiedImage);
        % drawnow limitrate is handled by mouseMotionCallback
    end

    function keyPressCallback(src, event)
        udata = get(src, 'UserData');
        hIm = udata.imageHandle;

        switch event.Key
            case 's' % Save the current image
                [filename, pathname] = uiputfile({'*.png';'*.jpg';'*.bmp'}, 'Save Erased Image As');
                if ischar(filename) && ischar(pathname)
                    fullPath = fullfile(pathname, filename);
                    imwrite(get(hIm, 'CData'), fullPath);
                    fprintf('Image saved to: %s\n', fullPath);
                end
            case 'r' % Reset the image
                set(hIm, 'CData', udata.originalImage);
                % Clear recorded movements upon reset
                udata.recordedMovements = zeros(0,3);
                set(src, 'UserData', udata);
                fprintf('Image reset to original state and recording cleared.\n');
            otherwise
                % Do nothing
        end
    end

    function figureCloseCallback(src,~)
        % This function is called when the user tries to close the figure
        % It allows 'uiwait' to return and the recordedMovements to be passed out.
        uiresume(src); % Resume execution after uiwait
    end

end