//
//  CaptureSession.swift
//  CoreML3
//
//  Created by Shota Nakagami on 2019/07/08.
//  Copyright © 2019 Shota Nakagami. All rights reserved.
//

import AVFoundation

class CaptureSession: NSObject {
    
    var onOutputImageBuffer: (_ cvPixelBuffer: CVPixelBuffer) -> Void = { _ in }
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        
    }
    
    func start() -> AVCaptureVideoPreviewLayer? {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: captureDevice),
            captureSession.canAddInput(input) else {
                assertionFailure()
                return nil
        }
        
        captureSession.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        
        guard captureSession.canAddOutput(output) else {
            assertionFailure()
            return nil
        }
        captureSession.addOutput(output)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer
        
        captureSession.startRunning()
        return previewLayer
    }
    
    func convertToLayerRect(from metadataOutputRect: CGRect) -> CGRect {
        guard let previewLayer = previewLayer else { return .zero }
        //var adjustedRect = metadataOutputRect
        //adjustedRect.origin.y = 1 - adjustedRect.origin.y
        // return previewLayer.layerRectConverted(fromMetadataOutputRect: adjustedRect)
        let size = previewLayer.frame.size
        let transform = CGAffineTransform.identity
            .scaledBy(x: 1, y: -1)
            .translatedBy(x: 0, y: -size.height)
            .scaledBy(x: size.width, y: size.height)

        //return previewLayer.layerRectConverted(fromMetadataOutputRect: metadataOutputRect.applying(transform))
        return metadataOutputRect.applying(transform)
    }
}

extension CaptureSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cvPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            assertionFailure()
            return
        }
        onOutputImageBuffer(cvPixelBuffer)
    }
}
