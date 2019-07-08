//
//  CaptureSession.swift
//  CoreML3
//
//  Created by Shota Nakagami on 2019/07/08.
//  Copyright © 2019 Shota Nakagami. All rights reserved.
//

import AVFoundation

class CaptureSession: NSObject {
    
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
        
        captureSession.startRunning()        
        return previewLayer
    }
}

extension CaptureSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
}
