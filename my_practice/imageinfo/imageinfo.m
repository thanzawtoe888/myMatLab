%Filename, FileModDate, FileSize, Format, Width, Height, BitDepth,
%ColorType, NumberOfSamples, CodingMethod and CodingProcess.

info = imfinfo('images\inputs\frame_0000.jpg');
image_name = info.Filename;

modification_date = info.FileModDate;

image_size = info.FileSize;
image_width = info.Width;
image_height = info.Height;
color_depth = info.BitDepth;
color_type = info.ColorType;
sample_number = info.NumberOfSamples;
coding_method = info.CodingMethod;
coding_process = info.CodingProcess;
