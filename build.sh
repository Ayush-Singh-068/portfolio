#!/bin/bash
set -e

echo "🚀 Starting Flutter web build on Vercel..."

# Install Flutter
echo "📦 Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter --version

# Get dependencies
echo "📚 Getting Flutter dependencies..."
flutter pub get

# Build web
echo "🔨 Building Flutter web app..."
flutter build web --release

echo "✅ Build completed successfully!"

