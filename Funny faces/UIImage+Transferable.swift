import SwiftUI
import UniformTypeIdentifiers

extension UIImage: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { image in
            image.pngData() ?? Data()
        }
    }
}
