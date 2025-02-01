//
//  DocumentCameraVCRepresentable.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 01/02/25.
//

import SwiftUI
import UIKit
import VisionKit

struct DocumentCameraVCRepresentable: UIViewControllerRepresentable {
    @Binding var scanResult: [UIImage]

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator

        return documentCameraViewController
    }

    func updateUIViewController(_: VNDocumentCameraViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(scanResult: $scanResult)
    }

    final class Coordinator: NSObject, @preconcurrency VNDocumentCameraViewControllerDelegate {
        @Binding var scanResult: [UIImage]

        init(scanResult: Binding<[UIImage]>) {
            _scanResult = scanResult
        }

        /// Tells the delegate that the user successfully saved a scanned document from the document camera.
        @MainActor
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true, completion: nil)
            scanResult = (0 ..< scan.pageCount).compactMap { scan.imageOfPage(at: $0) }
        }

        // Tells the delegate that the user canceled out of the document scanner camera.
        @MainActor
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
        }

        /// Tells the delegate that document scanning failed while the camera view controller was active.
        @MainActor
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document scanner error: \(error.localizedDescription)")
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
