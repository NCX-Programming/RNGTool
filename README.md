# RNGTool
The best way to generate random numbers on macOS 12+, iOS 15+, and watchOS 8+ (kinda)

[![Swift](https://github.com/NCX-Programming/RNGTool/actions/workflows/swift.yml/badge.svg)](https://github.com/NCX-Programming/RNGTool/actions/workflows/swift.yml)

<img width="1067" alt="A screenshot of RNGTool's dice mode, which features 18 dice on screen showing different results." src="https://github.com/user-attachments/assets/5031a060-0ac3-4c01-99ee-b36de0f7d14e" />
<sup>Image taken in release v3.0.0 (Build 7)</sup>

## Modes
### Numbers
Generate a single random number using only a minimum and maximum number. The simplest way to generate numbers. Now features fancy animations if run on iOS 16+ or macOS 13+!
### Dice
Generate numbers using your standard 6-sided dice. Supports up to 18 dice on macOS, 9 dice on iOS, and 2 dice on watchOS.
### Cards
Generate numbers by drawing a hand of cards. Optionally, you can display the point values of each card drawn, with the Ace being toggleable between 1 and 11 points. Supports up to 10 cards on macOS, 7 cards on iOS, and 3 cards on watchOS.
### Marbles
Generate letters by rolling some marbles. Supports up to 18 marbles on macOS, 9 marbles on iOS, and 3 marbles on watchOS.
## System Requirements
- Mac: At least macOS 12.4 or higher
- iOS Device: At least iOS/iPadOS 15.6 or higher
- Apple Watch: At least watchOS 8.3 or higher

## Installation (macOS, stable)
First, head to [the latest release](https://github.com/NCX-Programming/RNGTool/releases/latest) and download the macOS DMG. Mount it and move `RNGTool.app` to your Applications folder like any other program. To get around releases not being signed, you'll need to go into your Applications folder and Right Click -> Open the first time you install and after any updates to allow it past Gatekeeper.

> [!IMPORTANT]  
> Due to changes in macOS Sequoia, the Right Click -> Open method will no longer work. You'll need to instead use the command `xattr -d com.apple.quarantine RNGTool.app` to clear Gatekeeper's quarantine status. You only need to run this command once, as the app will open like normal afterwards.

## Installation (macOS, nightlies)
GitHub Actions automatically builds RNGTool and then creates a DMG installer for it every time we push a commit. Go [here](https://github.com/NCX-Programming/RNGTool/actions) to see the Actions runs, and download the macOS build from the most recent run. You will have to follow the same steps as the releases to run them for the first time.

## Installation (iOS/iPadOS, all)
Unfortunately, I am not an Apple Developer so I cannot distribute builds properly. IPA files are available for each release as well as all nightlies, just like on macOS, but you'll need to use a sideloading tool (such as [Sideloadly](https://sideloadly.io) or [AltStore](https://altstore.io)) to install them (or have a jailbroken device). If you have a Mac and know your way around Xcode, you can also clone the source and have Xcode install the app to your device as a development target (however with the same limitations as sideloading, as it'll only last for 7 days without a developer account).
