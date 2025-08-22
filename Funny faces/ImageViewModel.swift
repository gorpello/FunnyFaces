//
//  ImageViewModel.swift
//  Funny faces
//
//  Created by Gabriella Annunziata on 02/07/25.
//

import SwiftUI
import Combine
import Vision
import OSLog

let logger = Logger() as Logger

@MainActor
class ImageViewModel: ObservableObject {
    @Published var faceObservations: [VNFaceObservation] = []
    @Published var processedImage: UIImage? = nil
    @Published var errorMessage: String? = nil
    
    @Published var photoPickerViewModel: PhotoPickerViewModel
    
    init(photoPickerViewModel: PhotoPickerViewModel) {
        self.photoPickerViewModel = photoPickerViewModel
        // Observe for photo changes to reset overlays and errors
        photoPickerViewModel.$selectedPhoto
            .sink { [weak self] _ in
                self?.processedImage = nil
                self?.faceObservations = []
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func detectFaces() {
        guard let image = photoPickerViewModel.selectedPhoto?.image else {
            self.errorMessage = "No image available"
            return
        }
        guard let cgImage = image.cgImage else {
            self.errorMessage = "Failed to convert UIImage to CGImage"
            return
        }
        
        let request = VNDetectFaceLandmarksRequest { [weak self] request, error in
            if let error = error {
                self?.errorMessage = "Face detection error: \(error.localizedDescription)"
                return
            }
            let faces = (request.results as? [VNFaceObservation]) ?? []
            self?.faceObservations = faces
            self?.errorMessage = faces.isEmpty ? "No faces detected" : nil
            if let originalImage = self?.photoPickerViewModel.selectedPhoto?.image {
                self?.processedImage = originalImage.drawGooglyEyes(faceObservations: faces)
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            self.errorMessage = "Detection failed: \(error.localizedDescription)"
        }
    }
    
    // For storing Combine cancellables
    private var cancellables = Set<AnyCancellable>()
}
