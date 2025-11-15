#!/bin/bash
set -e

echo "🚀 Starting Flutter web build on Vercel..."

# Cache directory for Flutter SDK (Vercel caches $HOME by default)
FLUTTER_CACHE_DIR="$HOME/.flutter"
FLUTTER_DIR="$FLUTTER_CACHE_DIR/flutter"

# Install Flutter (with caching)
if [ ! -d "$FLUTTER_DIR" ]; then
    echo "📦 Installing Flutter SDK (first time or cache miss)..."
    mkdir -p "$FLUTTER_CACHE_DIR"
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_DIR"
else
    echo "✅ Using cached Flutter SDK..."
    cd "$FLUTTER_DIR"
    git fetch --depth 1
    git reset --hard origin/stable
    cd - > /dev/null
fi

export PATH="$PATH:$FLUTTER_DIR/bin"

# Verify installation
flutter --version

# Get dependencies
echo "📚 Getting Flutter dependencies..."
flutter pub get

# Build web
echo "🔨 Building Flutter web app..."
flutter build web --release

echo "✅ Build completed successfully!"

