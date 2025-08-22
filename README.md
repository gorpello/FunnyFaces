# Funny Faces

**Funny Faces** is a SwiftUI application that allows you to select photos from your library, detect faces in them, and highlight detected faces with rectangles. Explore and navigate through each detected face individually!

## The Purpose

Use the Vision Framework to perform various computer vision tasks, enabling your apps to analyze and understand the visual world

## Features

- Select photos from your photo library.
- Detect all faces in a selected photo using Apple's Vision framework.
- Highlight detected faces with visible rectangles.
- Navigate between different detected faces.

## Exercise

Your task is to create a new iOS project that uses the Vision framework to make funny overlays on faces in photos. This will require you to execute a Vision request and then manipulate the observation before using the observation data to draw on the screen.
You’re welcome to use any of the example code snippets from the various demo projects for this module. When drawing with CoreGraphics, the commands are executed back to front, meaning the first thing drawn will be in the back and the last thing drawn will be in the front.
Some possible useful functions:
The .draw function of a UIGraphicsContext lets you supply an image and a rectangle and draws the image inside the rectangle.
The UIBezierPath has a .ovalIn initializer for drawing ovals, also a .roundedRect initializer in addition to the .rect initializer you’ve seen already.
An array has min(by:) and max(by:) functions to return the minimum and maximum elements in a sequence.
Face landmark structures are an array of points. Your app can either just grab some of the points to decide where to place the funny overlays or you can use math to calculate exact locations. As long as the overlays completely cover the associated face landmarks and make the face look funny it’s good.
Requirements
The project type is a SwiftUI application with at least one main View and shall run on the simulator.

* Note: If the app uses a technology that requires a physical device that must be highlighted in the README for the app or with a runtime check and message to the user.

The project shall let the user import an image to the app and prominently display it on the main view.
The project shall have a clear mechanism to apply the funny face filter, tapping the picture or tapping a button for example. When there is no image, the user cannot tap or the mechanism shall inform them that they must import an image.
The project shall use VNDetectFaceRectanglesRequest or one of the related facial requests to generate VNFaceObservation objects and use the .landmarks property to identify the location of the eyes or pupils.
The app shall draw a large white circle over each eye and a smaller black circle inside the large white circle to give the effect of googly eyes. Alternatively the app may use images of googly eyes from the app bundle to draw over the eyes.
The app shall run without crashing.

* For extra credit:
Use a ShareLink to let your user share their finished project.
Give the user choices on the facial features to modify, like only mouth, only left eye, etc. and display an overlay such as sunglasses, or a goofy smile.
For extra extra credit (warning, this part could take a long time and requires your app to run on a device):
Use an AVCaptureSession to use the video camera so that you can draw on a face in real time. Don’t forget you’ll need to ask for extra permissions or the app will crash.
Set up the video camera to return a CMSampleBuffer and then use the initializer for VNImageRequestHandler that takes a CMSampleBuffer to process the buffer.

## How to Use

1. **Run the app** in Xcode on a supported Apple platform (macOS or iOS*).
2. **Select a photo** from your library.
3. Tap **Detect Faces** to run Vision face detection.
4. Use **Previous** and **Next** to cycle through detected faces—the current face will be highlighted with a rectangle.

## Requirements

- Xcode 15 or newer
- Swift 5.9 or newer
- SwiftUI
- Vision framework
- PhotosUI framework
- iOS 17+ or macOS 14+ (depending on your deployment target)

## Getting Started

1. Clone the repository.
2. Open the project in Xcode.
3. Select a simulator or device and run.

## Credits

Created by Gianluca Orpello.  
Uses Apple's Vision and PhotosUI frameworks.

## License

MIT License. See [LICENSE](LICENSE) for details.

---

*Make sure to grant the app access to your Photos library when prompted.*

