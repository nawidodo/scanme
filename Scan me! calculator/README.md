# Scan me! calculator

This is an iOS app that allows the user to select an image from their camera roll or builtin camera and perform Optical Character Recognition (OCR) on it. The app uses the Vision framework for OCR and Firestore as the cloud database.

## Requirements

- Xcode 12 or above
- iOS 13 or above
- CocoaPods

## Installation

1. Clone this repository
2. Run `pod install` in the project directory
3. Open `Scan me! calculator.xcworkspace` in Xcode
4. Choose either the `app-red-camera-roll` or `app-green-camera-roll` scheme to run the app (Note: Using any other scheme may cause the app to crash due to the lack of a built-in camera in the simulator)

## Usage

1. Launch the app
2. Grant the app permission to access your photo library if prompted
3. Select an image from your camera roll or capture from built-in camera
4. Wait for the OCR process to complete
5. View the recognized text in the app
6. Move between tab to save/load data from local file or cloud db

Note: Image selection from the built-in camera may produce inconsistent OCR results compared to selecting an image from the camera roll.

## Cloud Database

The app uses Firestore as the cloud database. Please provide your own Firebase configuration file and add it to the project directory. Due to heavy dependencies, the compile time may be long.

## Compatibility

The app has been tested on iOS 13 and above.

## Unit Testing

To run unit tests, choose either the `app-red-camera-roll` or `app-green-camera-roll` scheme and run the tests from Xcode.