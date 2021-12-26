# RNGTool
The best way to generate random numbers on macOS 11.3+ and iOS 15.0+ (kinda)

![](https://github.com/NCX-Programming/RNGTool/workflows/Swift/badge.svg?branch=main)

<image src="https://cdn.ncxprogramming.com/file/image/screenshots/rngtool/repoimage.png" hight=397 width=630/>

Image taken in v1.8 Beta (Build 159) This screenshot was taken on a non-retina display, but images shown appear higher quality on retina displays.
## Modes:
- Numbers only
- Dice
- Cards
- Marbles
### Numbers
Generate a single random number using only a minimum and maximum number. The simplest way to generate numbers.
### Dice
Generate up to 6 random numbers using dice with 6-20 sides. Now featuring dice icons showing your rolls when using 6-sided dice.
### Cards
Generate up to 5 random numbers using cards. You can display the numbers, cards drawn, and the point values of them. Will output the cards as either only numbers (1-13), or including face cards (Ace, 1-10, Jack, Queen, King). The point value is toggleable and you can change whether the Ace is worth 1 or 11 points.
### Marbles
Generate up to 5 random numbers and letters using marbles. Marble icons are shown with the letter on them. You can also show a list of letters below the list of numbers.
## System Requirements
- At least macOS 11.3 or higher
## Installation
GitHub Actions automatically builds RNGTool and then creates a DMG installer for it every time we push a commit. Click [here](https://nightly.link/NCX-Programming/RNGTool/workflows/swift/main/RNGTool-Installer-latest.dmg.zip) to download the latest successful build, or [here](https://github.com/NCX-Programming/RNGTool/actions) to view all runs. You will have to Right Click > Open the first time you try and run the program in order to get past Gatekeeper, as unfortunately these binaries are not signed. An auto-generated checksum is also available if you'd like to verify the file before installing it. ([Download latest checksum file](https://nightly.link/NCX-Programming/RNGTool/workflows/swift/main/RNGTool-Checksums.zip))
These direct download links are provided by [nightly.link](https://nightly.link)
## iOS
An iOS version of RNGTool now exists, however I am not an Apple Developer so I cannot distribute builds properly. I am planning to provide IPAs in both releases and actions, but you'll need to use a sideloading tool such as [Sideloadly](https://sideloadly.io) or [AltStore](https://altstore.io) or have a jailbroken device. Another way, if you have a Mac, is to clone the source and have Xcode install the app to your device as a development target (this shares the same limitations as sideloading though, as it'll only last for 7 days without a developer account).
