//
//  ViewController.swift
//  CoreML3
//
//  Created by Shota Nakagami on 2019/07/08.
//  Copyright © 2019 Shota Nakagami. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    private let captureSession = CaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPreviewLayer()
        setVision()
    }
    
    private func setPreviewLayer() {
        guard let previewLayer = captureSession.start() else { return }
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    private func setVision() {
        captureSession.onOutputImageBuffer = { [weak self] cvPixelBuffer in
            let request = VNGenerateObjectnessBasedSaliencyImageRequest() { vnRequest, error in
            // let request = VNGenerateAttentionBasedSaliencyImageRequest() { vnRequest, error in
                guard let self = self else { return }
                guard let results = vnRequest.results as? [VNSaliencyImageObservation] else { return }
                results.forEach { result in
                    result.salientObjects?.forEach { salientObject in
                        DispatchQueue.main.async {
                            self.drawRect(for: salientObject.boundingBox, alpha: CGFloat(salientObject.confidence))
                        }
                    }
                }
            }
            
            try? VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:]).perform([request])
        }
    }
    
    private func drawRect(for metadataOutputRect: CGRect, alpha: CGFloat) {
        let layerRect = captureSession.convertToLayerRect(from: metadataOutputRect)
        let overlay = UIView(frame: layerRect)
        view.addSubview(overlay)
        overlay.layer.borderWidth = 0.5
        overlay.layer.borderColor = UIColor.green.cgColor
        overlay.alpha = alpha
        UIView.animate(withDuration: 3, animations: {
            overlay.alpha = 0
        }, completion: { _ in
            overlay.removeFromSuperview()
        })
    }
}

