#!/usr/bin/env bash

# Since create-dmg does not clobber, be sure to delete previous DMG
[[ -f RNGTool-Installer.dmg ]] && rm RNGTool-Installer.dmg

# Create the DMG
create-dmg \
  --volname "RNGTool Installer" \
  --volicon "RNGToolDMG.icns" \
  --background "background.png" \
  --window-pos 200 120 \
  --window-size 500 375 \
  --icon-size 80 \
  --icon "RNGTool.app" 125 175 \
  --hide-extension "RNGTool.app" \
  --app-drop-link 375 175 \
  "RNGTool-Installer.dmg" \
  "source_folder/"