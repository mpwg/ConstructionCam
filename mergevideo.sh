#!/bin/bash

# Input directory containing AVI files
input_dir="/path/to/avi/files"

# Output directory to save the MP4 file
output_dir="/path/to/output/directory"

# Generate a unique filename for the output MP4 file
output_file="$(date +"%Y%m%d_%H%M%S").mp4"

# ffmpeg parameters
concat_arg="-f concat -safe 0 -i -"
# Use software encoding with libx265
codec_arg="-c:v libx265 -crf 28 -preset medium -c:a aac -b:a 128k"
# Use hardware encoding with VideoToolbox on macOS (requires ffmpeg compiled with --enable-videotoolbox)
#codec_arg="-c:v hevc_videotoolbox -b:v 8000k -c:a aac -b:a 128k"
# Use hardware encoding with nvenc on Linux (requires ffmpeg compiled with --enable-nvenc)
#codec_arg="-c:v hevc_nvenc -preset slow -cq 28 -c:a aac -b:a 128k"

# Use find and ffmpeg to convert the AVI files to h.265 encoded MP4 and save to the output directory
echo "Converting AVI files to MP4..."
echo "Input directory: $input_dir"
echo "Output directory: $output_dir"
echo "Output file: $output_file"
echo "ffmpeg parameters:"
echo "Concatenation argument: $concat_arg"
echo "Codec argument: $codec_arg"
echo ""

# Find all AVI files in the input directory and sort them by date in a null-separated list
# Pass the sorted list of AVI files to ffmpeg to concatenate and encode them as a h.265 MP4 file
find "$input_dir" -type f -name "*.avi" -print0 | sort -z -t_ -k3,3 -k2,2 -k1,1 | xargs -0 ffmpeg $concat_arg $codec_arg "$output_dir/$output_file"
