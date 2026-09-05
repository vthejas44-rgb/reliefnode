#!/usr/bin/env bash
set -e

echo "============================================="
echo "  ReliefNode: Building Static Web Deployments"
echo "============================================="

# Create public distribution directory
mkdir -p public/volunteer

# 1. Copy Victim Captive Portal to root of public/
echo "[1/3] Preparing Victim Captive Portal..."
cp frontend/index.html public/index.html

# 2. Build Flutter Web App
echo "[2/3] Compiling Flutter Volunteer App..."
cd mobile_app
flutter pub get
flutter build web --release --base-href "/volunteer/"
cd ..

# 3. Copy Flutter Web build artifacts to public/volunteer/
echo "[3/3] Copying Flutter web bundle to public/volunteer/..."
cp -R mobile_app/build/web/* public/volunteer/

echo "============================================="
echo "Build complete! Dual deployment ready in /public"
echo "  - Victim Portal:   http://localhost:8080/"
echo "  - Volunteer Mule:  http://localhost:8080/volunteer/"
echo "============================================="
