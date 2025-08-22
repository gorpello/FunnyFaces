//
//  ContentView.swift
//  Funny faces
//
//  Created by Gabriella Annunziata on 02/07/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel: ImageViewModel

    var body: some View {
        VStack {
            PhotosPicker(selection: $viewModel.photoPickerViewModel.imageSelection, matching: .images) {
                Label("Choose Photo", systemImage: "photo")
            }
            .padding(.top)
            
            if let image = viewModel.processedImage ?? viewModel.photoPickerViewModel.selectedPhoto?.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                Text("No image available")
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            if viewModel.photoPickerViewModel.selectedPhoto != nil {
                Button("Detect Faces & Apply Googly Eyes") {
                    viewModel.detectFaces()
                }
                .padding()
            }

            // ShareLink (shown only when a processed image is available)
            if let processedImage = viewModel.processedImage {
                ShareLink(item: processedImage, preview: SharePreview("Googly Eyes Photo", image: Image(uiImage: processedImage))) {
                    Label("Share Image", systemImage: "square.and.arrow.up")
                }
                .padding(.vertical)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}
