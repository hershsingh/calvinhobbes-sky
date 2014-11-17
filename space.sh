#!/bin/bash

# Exit if any command fails
set -e

# Parameters
resolution=1600x900
img_src=sky/sky0.jpg
img_calvinhobbes=calvinhobbes_clear.png
img_output=background.png

# Intermediate Images
img_black=black.png
img_gradient=gradient.png
img_src_resized=source.png
img_sky_transparent=sky_transparent.png
img_sky_blended=sky_blended.png

# Check if the required files exist
if [ ! -f $img_src ]; then 
    echo Error: The sky image file is missing. 
    exit 1
fi
if [ ! -f $img_calvinhobbes ]; then 
    echo Error: Calvin and Hobbes overlay image file is missing.
    exit 1
fi

# Make Gradient
if [ ! -f $img_gradient ]; then
    echo "Creating gradient..."
    convert  -alpha Off -size $resolution gradient: -sigmoidal-contrast 10,30% $img_gradient
fi
if [ ! -f $img_black ]; then
    echo "Creating black backdrop..."
    convert  -alpha Off -size $resolution xc:black $img_black
fi

# Resize sky image
convert -alpha Off -resize $resolution\! $img_src $img_src_resized

# Use the gradient as an opacity mask to fade the sky image into zero opacity
convert $img_src_resized $img_gradient -alpha Off \
        -compose CopyOpacity -composite $img_sky_transparent
# Compose the transparent sky with black background 
convert $img_black $img_sky_transparent -gravity South -composite $img_sky_blended
# Paste Calvin & Hobbes on top of the background
convert $img_sky_blended $img_calvinhobbes -gravity South -composite $img_output
