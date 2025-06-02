#!/bin/bash

# Organize Olivia CEM Splash Animation files for handoff
# This script separates core files from demo/example files

echo "Organizing Olivia CEM Splash Animation for handoff..."

# Create directories
mkdir -p Core
mkdir -p Examples/UI
mkdir -p Examples/Demo

# Move core files (essential for integration)
cp SplashView.swift Core/
cp SplashViewModel.swift Core/
cp olivia-cem-splash-prod.riv Core/
cp README.md Core/
cp TESTING.md Core/

# Move example UI components 
mv InputField.swift Examples/UI/ 2>/dev/null || :
mv CustomToggle.swift Examples/UI/ 2>/dev/null || :
mv Button.swift Examples/UI/ 2>/dev/null || :
mv AppColors.swift Examples/UI/ 2>/dev/null || :
mv LoginView.swift Examples/UI/ 2>/dev/null || :

# Move demo app files
cp ContentView.swift Examples/Demo/
cp OliviaCEMSplashApp.swift Examples/Demo/
mv Examples/RiveViewModel-OLD.swift Examples/Demo/ 2>/dev/null || :

echo "Done! Files are now organized into Core and Examples directories."
echo ""
echo "=== HANDOFF INSTRUCTIONS ==="
echo "1. Provide the 'Core' directory to developers for integration"
echo "2. Include 'Examples' directory as reference material"
echo "3. Ensure RiveRuntime.xcframework is included or they use SPM"
echo "===========================" 
