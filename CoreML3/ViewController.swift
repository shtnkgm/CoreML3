//
//  ViewController.swift
//  CoreML3
//
//  Created by Shota Nakagami on 2019/07/08.
//  Copyright © 2019 Shota Nakagami. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let captureSession = CaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let previewLayer = captureSession.start() else { return }
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
    }


}

