//
//  NativeCameraView.swift
//  Runner
//
//

import Flutter
import UIKit
import AVFoundation

class NativeCameraViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        return NativeCameraView(frame: frame, viewIdentifier: viewId, binaryMessenger: messenger);
    }
}

class CameraPreviewView: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer? {
            didSet {
                if let layer = previewLayer {
                    layer.videoGravity = .resizeAspectFill
                    self.layer.addSublayer(layer)
                }
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = self.bounds
        }
}

class NativeCameraView: NSObject, FlutterPlatformView, FlashlightApi {
    private var _view: CameraPreviewView
    private var captureSession: AVCaptureSession?
    private var captureDevice: AVCaptureDevice?
    
    init(frame: CGRect, viewIdentifier viewId: Int64, binaryMessenger messenger: FlutterBinaryMessenger) {
        _view = CameraPreviewView(frame: frame)
        _view.clipsToBounds = true
        super.init()
        
        FlashlightApiSetup.setUp(binaryMessenger: messenger, api: self)
        setupCamera()
    }
    
    func view() -> UIView { return _view }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        
        guard let session = captureSession else {return}
        
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {return}
        self.captureDevice = device
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print("Nie można dodać kamery: \(error)")
        }
        session.commitConfiguration()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        _view.previewLayer = previewLayer
        _view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
        
    }
    
    func toggleFlashlight(isOn: Bool) throws {
        guard let device = captureDevice, device.hasTorch else {return}
        
        do {
            try device.lockForConfiguration()
            device.torchMode = isOn ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Błąd latarki: \(error)")
        }
    }
}
