# VibeWhisper

Welcome to **VibeWhisper**!

## macOS Installation Guide

To install the application on your Mac, follow these instructions:

### Prerequisites
- A Mac running macOS 10.14 or later.

### Installation Steps

1. **Locate the Installer** 
   You can find the generated installer inside the `build` folder of this project:
   `build/VibeWhisper-Installer.dmg`

2. **Mount the Image**
   Double-click the `VibeWhisper-Installer.dmg` file to mount the disk image. A new window will appear showing the `VibeWhisper` application icon and an `Applications` folder shortcut.

3. **Install the Application**
   Drag and drop the **"VibeWhisper"** icon into the **"Applications"** folder shortcut right next to it.

4. **Launch the App**
   Open your Mac's `Applications` folder (or use Spotlight by pressing `Cmd + Space`) and search for **VibeWhisper**. Double-click the application to launch it.

### Troubleshooting (Unverified Developer Warning)
Because this build may not be codesigned with an Apple Developer Certificate, macOS might show a warning that the app cannot be opened because the developer cannot be verified. 
If this happens:
1. Go to your Mac's **System Settings** > **Privacy & Security**.
2. Scroll down to the **Security** section.
3. You will see a message saying "VibeWhisper was blocked from use...". Click the **Open Anyway** button.
4. Confirm your choice, and the application will open. You will only need to do this the first time you run the application.

---

### Need to generate a new build?

If you made code changes and need to generate a fresh macOS build and installer, run the following commands from the terminal in the root of the project:

```bash
# 1. Generate the macOS release build
flutter build macos --release

# 2. Package it into a DMG
mkdir -p build/installer
cp -r build/macos/Build/Products/Release/VibeWhisper.app build/installer/
ln -s /Applications build/installer/Applications
hdiutil create -volname "VibeWhisper" -srcfolder build/installer -ov -format UDZO build/VibeWhisper-Installer.dmg
rm -rf build/installer
```
