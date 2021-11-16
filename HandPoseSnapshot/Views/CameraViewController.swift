//
//  CameraViewController.swift
//  HandPoseSnapshot
//
//  Created by Brayden Harris on 11/12/21.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var shutterButtonView: UIView!

    // MARK: - Properties
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.frame = view.frame
        return preview
    }()
    let photoOutput = AVCapturePhotoOutput()
    var capturingPhoto = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        checkAuthorization()

        // setup shutter button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        shutterButtonView.addGestureRecognizer(tapGesture)
    }

    private func checkAuthorization() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorizationStatus {
        case .authorized:
            setupAVSession()
            self.view.layer.insertSublayer(self.previewLayer, below: self.countdownView.layer)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if authorized {
                    DispatchQueue.main.async {
                        self.setupAVSession()
                        self.view.layer.insertSublayer(self.previewLayer, below: self.countdownView.layer)
                    }
                }
            }
        case .denied:
            print("You denied camera permission!")
        case .restricted:
            print("Sorry, can't use this app!")
        @unknown default:
            print("This is new...")
        }
    }

    @objc
    private func shutterTapped() {
        capturePhoto()
    }

    private func setupAVSession() {
        do {
            captureSession.beginConfiguration()
            try setupInput()
            try setupPhotoOutput()
            captureSession.commitConfiguration()
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }

    private func setupInput() throws {
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        let deviceInput = try AVCaptureDeviceInput(device: frontCamera)

        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        } else {
            throw CaptureSessionError.cantAddInput
        }
    }

    private func setupPhotoOutput() throws {
        photoOutput.isHighResolutionCaptureEnabled = true
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            throw CaptureSessionError.cantAddPhotoOutput
        }
    }

    private func capturePhoto() {
        DispatchQueue.main.async {
            self.countdownView.startTimer()
            self.countdownView.countdownCompletion = {
                let photoSettings = AVCapturePhotoSettings()
                self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
            }
        }
    }

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }

        let previewVC = PreviewViewController(previewImage: image)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}
