#!/bin/bash
# Update app and reinstall

echo "Building Linux application..."
# Rebuild Flutter app
flutter build linux --release

echo "Incrementing package release number..."
# Get current PKGBUILD content
PKGBUILD_CONTENT=$(cat PKGBUILD)

# Extract current pkgrel 
if [[ $PKGBUILD_CONTENT =~ pkgrel=([0-9]+) ]]; then
  CURRENT_PKGREL="${BASH_REMATCH[1]}"
  echo "Current pkgrel: $CURRENT_PKGREL"
  
  # Increment it
  NEW_PKGREL=$((CURRENT_PKGREL + 1))
  echo "New pkgrel: $NEW_PKGREL"
  
  # Write updated PKGBUILD using awk for more precise replacement
  awk -v new="pkgrel=$NEW_PKGREL" '{ gsub(/pkgrel=[0-9]+/, new); print }' PKGBUILD > PKGBUILD.new
  mv PKGBUILD.new PKGBUILD
  
  echo "Updated PKGBUILD with new release number"
else
  echo "ERROR: Could not find pkgrel in PKGBUILD"
  exit 1
fi

echo "Building and installing package..."
# Build and install package
makepkg -si