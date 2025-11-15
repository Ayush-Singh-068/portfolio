#!/bin/bash

# Script to generate all required icon sizes from a source image
# Usage: ./generate_icons.sh path/to/your/icon.png

if [ -z "$1" ]; then
    echo "Usage: ./generate_icons.sh path/to/your/icon.png"
    echo "Example: ./generate_icons.sh ~/Desktop/my-icon.png"
    exit 1
fi

SOURCE_IMAGE="$1"

if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "Error: Source image not found: $SOURCE_IMAGE"
    exit 1
fi

echo "Generating icons from: $SOURCE_IMAGE"

# Generate favicon (32x32)
sips -z 32 32 "$SOURCE_IMAGE" --out web/favicon.png

# Generate app icons
sips -z 192 192 "$SOURCE_IMAGE" --out web/icons/Icon-192.png
sips -z 512 512 "$SOURCE_IMAGE" --out web/icons/Icon-512.png
sips -z 192 192 "$SOURCE_IMAGE" --out web/icons/Icon-maskable-192.png
sips -z 512 512 "$SOURCE_IMAGE" --out web/icons/Icon-maskable-512.png

echo "✅ All icons generated successfully!"
echo "Icons created in:"
echo "  - web/favicon.png"
echo "  - web/icons/Icon-192.png"
echo "  - web/icons/Icon-512.png"
echo "  - web/icons/Icon-maskable-192.png"
echo "  - web/icons/Icon-maskable-512.png"

