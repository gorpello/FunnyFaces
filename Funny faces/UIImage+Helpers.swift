//
//  UIImage+Helpers.swift
//  Funny faces
//
//  Created by Gabriella Annunziata on 02/07/25.
//

import UIKit
import Vision
import OSLog

extension UIImage {
    /// Draws googly eyes on the image using face observations and landmarks.
    ///
    /// - Parameter faceObservations: Array of VNFaceObservation with landmarks.
    /// - Returns: A new UIImage with googly eyes overlays (if possible).
    func drawGooglyEyes(faceObservations: [VNFaceObservation]) -> UIImage? {
        guard let cgImage = self.cgImage else { return self }
        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        // Use self.draw to respect orientation
        self.draw(in: CGRect(origin: .zero, size: imageSize))

        for face in faceObservations {
            guard let landmarks = face.landmarks else { continue }

            func drawGooglyEye(_ points: VNFaceLandmarkRegion2D?) {
                guard let points = points, points.pointCount > 0 else { return }

                let mapped = points.normalizedPoints.map { p -> CGPoint in
                    let imageWidth = imageSize.width
                    let imageHeight = imageSize.height

                    // Step 1: Face bounding box in image coordinates
                    let bbox = face.boundingBox
                    let originX = bbox.origin.x * imageWidth
                    let originY = (1 - bbox.origin.y - bbox.size.height) * imageHeight // Flip Y

                    let faceRect = CGRect(
                        x: originX,
                        y: originY,
                        width: bbox.size.width * imageWidth,
                        height: bbox.size.height * imageHeight
                    )

                    // Step 2: Landmark point in face rect (normalized, origin lower left)
                    let landmarkX = CGFloat(p.x) * faceRect.width
                    let landmarkY = (1 - CGFloat(p.y)) * faceRect.height // Flip Y

                    // Step 3: Combine
                    return CGPoint(x: faceRect.origin.x + landmarkX,
                                   y: faceRect.origin.y + landmarkY)
                }

                // Center at centroid of points
                let count = CGFloat(mapped.count)
                let center = mapped.reduce(CGPoint.zero) { acc, pt in
                    CGPoint(x: acc.x + CGFloat(pt.x) / count, y: acc.y + CGFloat(pt.y) / count)
                }

                // Eye size: max distance between points, or bounding box as fallback
                let xs = mapped.map { CGFloat($0.x) }
                let ys = mapped.map { CGFloat($0.y) }
                let width = (xs.max() ?? 0) - (xs.min() ?? 0)
                let height = (ys.max() ?? 0) - (ys.min() ?? 0)
                let eyeDiameter = max(width, height) * 1.6 // A bit larger for effect
                let eyeRect = CGRect(
                    x: center.x - eyeDiameter/2,
                    y: center.y - eyeDiameter/2,
                    width: eyeDiameter,
                    height: eyeDiameter
                )
                UIColor.white.setFill()
                context.fillEllipse(in: eyeRect)
                // Draw black pupil (small circle/random offset for fun)
                let pupilRadius = eyeDiameter * 0.4
                let offset = CGFloat.random(in: -pupilRadius/3 ... pupilRadius/3)
                let pupilCenter = CGPoint(x: center.x + offset, y: center.y + offset)
                let pupilRect = CGRect(
                    x: pupilCenter.x - pupilRadius/2,
                    y: pupilCenter.y - pupilRadius/2,
                    width: pupilRadius,
                    height: pupilRadius
                )
                UIColor.black.setFill()
                context.fillEllipse(in: pupilRect)
            }

            drawGooglyEye(landmarks.leftEye)
            drawGooglyEye(landmarks.rightEye)
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}

extension UIViewController {
    /// Presents a share sheet to share the provided image.
    func share(image: UIImage, sourceView: UIView? = nil) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        // For iPad: Present as popover from the sourceView if provided
        if let popover = activityVC.popoverPresentationController, let sourceView = sourceView ?? self.view {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
        }
        self.present(activityVC, animated: true, completion: nil)
    }
}
