# RNGTool
The best way to generate random numbers on macOS 12+, iOS 15+, and watchOS 8+

[![Swift](https://github.com/NCX-Programming/RNGTool/actions/workflows/swift.yml/badge.svg)](https://github.com/NCX-Programming/RNGTool/actions/workflows/swift.yml)

<a href="https://apps.apple.com/us/app/rngtool/id6748287907?itscg=30200&itsct=apps_box_badge&mttnsubad=6748287907" style="display: inline-block;">
    <img src="https://toolbox.marketingtools.apple.com/api/v2/badges/download-on-the-app-store/black/en-us?releaseDate=1751846400" alt="Download on the App Store" style="width: 246px; height: 82px; vertical-align: middle; object-fit: contain;" />
</a>

<img width="1067" alt="A screenshot of RNGTool's dice mode, which features 18 dice on screen showing different results." src="https://github.com/user-attachments/assets/5031a060-0ac3-4c01-99ee-b36de0f7d14e" />

<sup>Image taken in release v3.0.0 (Build 7)</sup>

## Modes
### Numbers
Generate a single random number using only a minimum and maximum number. The simplest way to generate numbers. Now features fancy animations if run on iOS 16+ or macOS 13+!
### Coins
Flip a series of coins! Supports flipping 100 consecutive coins on macOS, 50 coins on iOS, and single coins on watchOS.
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
First, head to [the latest release](https://github.com/NCX-Programming/RNGTool/releases/latest) and download the macOS DMG. Mount it and move `RNGTool.app` to your Applications folder like any other program. RNGTool releases are notarized as of v3.0.1, so no special steps are required now. Also as of v3.0.1, RNGTool is also available on the Mac App Store! There's no functional difference between these two releases, so you can get RNGTool from whichever platform you prefer.

## Installation (macOS, nightlies)
GitHub Actions automatically builds RNGTool and then creates a DMG installer for it every time we push a commit. Go [here](https://github.com/NCX-Programming/RNGTool/actions) to see the Actions runs, and download the macOS build from the most recent run. To get around releases not being signed, you'll need to go into your Applications folder and Right Click -> Open the first time you install and after any updates to allow it past Gatekeeper.

> [!IMPORTANT]  
> Due to changes in macOS Sequoia, the Right Click -> Open method will no longer work. You'll need to instead use the command `xattr -d com.apple.quarantine RNGTool.app` to clear Gatekeeper's quarantine status. You only need to run this command once, as the app will open like normal afterwards. None of these steps are required if using release builds, only nightly builds are unsigned.

## Installation (iOS/iPadOS/watchOS)
As of v3.0.1, RNGTool has made its way to the App Store! You can get to the store page from either the big button at the top of the README, or by clicking [here](https://apps.apple.com/us/app/rngtool/id6748287907). IPAs are still provided for nightly builds and in the GitHub releases and can be sideloaded using any typical sideloading tools, but the recommended method of installation is the App Store. The App Store release of RNGTool is also how you can access the Apple Watch app.
