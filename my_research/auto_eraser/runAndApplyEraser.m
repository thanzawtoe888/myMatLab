% Main script to demonstrate recording and applying eraser movements.

% --- Step 1: Record Eraser Movements ---
fprintf('Starting the recording phase of the eraser tool.\n');
fprintf('Perform your desired erasing on the initial image.\n');
fprintf('Close the figure window when you are done to save the recording.\n');

% Call the recording tool. It will launch a figure and return the movements
% once the figure is closed by the user.
recorded_eraser_strokes = interactiveEraserToolWithBrushSizeAndRecording();

if isempty(recorded_eraser_strokes)
    fprintf('No movements were recorded. Exiting script.\n');
    return; % Exit if no movements were captured
else
    fprintf('Successfully recorded %d erase points.\n', size(recorded_eraser_strokes, 1));
end

% --- Step 2: Upload the Second Frame (Target Image) ---
fprintf('\n--- Uploading Second Frame ---\n');
fprintf('Please select the image file you want to apply the erasures to.\n');

% Open a file selection dialog to let the user choose the second frame
[filename, pathname] = uigetfile({'*.png';'*.jpg';'*.bmp';'*.tif';'*.*'}, 'Select the Second Frame Image');

% Check if the user selected a file or cancelled
if isequal(filename, 0) || isequal(pathname, 0)
    fprintf('User cancelled image selection. Exiting script.\n');
    return;
else
    fullImagePath = fullfile(pathname, filename);
    fprintf('Loading second frame: %s\n', fullImagePath);
    
    try
        secondFrame = imread(fullImagePath);
        fprintf('Second frame loaded successfully.\n');
    catch ME
        warning('Error loading second frame "%s": %s. Exiting script.', fullImagePath, ME.message);
        return;
    end
end

% Ensure the second frame is binarized if it's not already.
% The erasing logic works best on logical (0/1) images.
if ~islogical(secondFrame)
    fprintf('Converting second frame to binary (black and white).\n');
    secondFrame = imbinarize(secondFrame);
end

% --- Step 3: Apply the recorded movements to the second frame ---
fprintf('Applying recorded movements to the uploaded second frame...\n');
applied_frame = applyRecordedEraserToFrame(secondFrame, recorded_eraser_strokes);

% --- Step 4: Display and Save the Results ---
fprintf('\n--- Displaying and Saving Results ---\n');
figure('Name', 'Eraser Application Results', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(secondFrame);
title('Uploaded Second Frame');

subplot(1, 2, 2);
imshow(applied_frame);
title('Second Frame with Erasures Applied');

% Ask user where to save the output
[saveFilename, savePathname] = uiputfile({'*.png';'*.jpg';'*.bmp'}, 'Save Erased Second Frame As');

if isequal(saveFilename, 0) || isequal(savePathname, 0)
    fprintf('Saving cancelled by user.\n');
else
    output_filename_applied = fullfile(savePathname, saveFilename);
    try
        imwrite(applied_frame, output_filename_applied);
        fprintf('Saved new frame with erasures to: %s\n', output_filename_applied);
    catch ME
        warning('Error saving applied image "%s": %s', output_filename_applied, ME.message);
    end
end

fprintf('Script finished.\n');