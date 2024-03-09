# RNGTool
The best way to generate random numbers on macOS 11.3+ and iOS 15.0+ (kinda)

![](https://github.com/NCX-Programming/RNGTool/workflows/Swift/badge.svg?branch=main)

<image src="https://cdn.ncxprogramming.com/file/image/screenshots/rngtool/repoimage.png" hight=397 width=630/>

<sup>Image taken in v1.8 Beta (Build 159) This screenshot was taken on a non-retina display, but images shown appear higher quality on retina displays.</sup>
## Modes
### Numbers
Generate a single random number using only a minimum and maximum number. The simplest way to generate numbers.
### Dice
Generate up to 6 random numbers using 6-sided dice.
### Cards
Generate up to 7 random numbers using cards. You can optionally display the point values of the cards drawn, with the Ace being toggleable between 1 and 11 points.
### Marbles
Generate up to 5 random letters using marbles. Marble icons are shown with the letter on them.
## System Requirements
- Mac: At least macOS 11.3 or higher
- iOS Device: At least iOS/iPadOS 15.0 or higher
- Apple Watch: Any watch that is up to date and paired to a phone supported by RNGTool

## Installation (macOS, stable)
First, head to [the releases](https://github.com/NCX-Programming/RNGTool/releases) and download the latest DMG. Mount it and move `RNGTool.app` to your Applications folder like any other program. To get around the build not being signed, you'll need to go into your Applications folder and Right Click > Open the first time you install and after any updates to allow it past Gatekeeper.

## Installation (macOS, nightlies)
GitHub Actions automatically builds RNGTool and then creates a DMG installer for it every time we push a commit. Click [here](https://nightly.link/NCX-Programming/RNGTool/workflows/swift/main/RNGTool-Installer-latest.dmg.zip) to download the latest successful build, or [here](https://github.com/NCX-Programming/RNGTool/actions) to view all runs. You will have to Right Click > Open the first time you try and run the program in order to get past Gatekeeper, as unfortunately these binaries are not signed. An auto-generated checksum is also available if you'd like to verify the file before installing it. ([Download latest checksum file](https://nightly.link/NCX-Programming/RNGTool/workflows/swift/main/RNGTool-Checksums.zip))
These direct download links are provided by [nightly.link](https://nightly.link)

## Installation (iOS/iPadOS, all)
Unfortunately, I am not an Apple Developer so I cannot distribute builds properly. IPA files are available from the releases as well as nightlies, just like on macOS, but you'll need to use a sideloading tool (such as [Sideloadly](https://sideloadly.io) or [AltStore](https://altstore.io)) or have a jailbroken device. If you have a Mac and know your way around Xcode, you can also clone the source and have Xcode install the app to your device as a development target (however with the same limitations as sideloading, as it'll only last for 7 days without a developer account).
