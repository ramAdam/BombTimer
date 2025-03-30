#!/bin/bash
# Update app and reinstall

# Rebuild Flutter app
flutter build linux --release

# Increment release number
sed -i 's/pkgrel=.*/pkgrel=$(($(grep pkgrel PKGBUILD | cut -d= -f2) + 1))/' PKGBUILD

# Build and install package
makepkg -si