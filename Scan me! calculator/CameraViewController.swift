//
//  ViewController.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 29/04/23.
//

import UIKit
import AVFoundation
import Vision

class CameraController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // AVCapture variables
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    // Vision variables
    let textRecognitionRequest = VNRecognizeTextRequest()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up AVCaptureSession
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print(error.localizedDescription)
            return
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        captureSession.addOutput(videoOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)

        // Set up textRecognitionRequest
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true

        // Start AVCaptureSession
        captureSession.startRunning()
    }

    // AVCaptureVideoDataOutputSampleBufferDelegate method
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // Create a request handler using the pixel buffer
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        do {
            // Perform text recognition on the pixel buffer
            try requestHandler.perform([textRecognitionRequest])

            // Process the recognized text
            guard let observations = textRecognitionRequest.results else { return }
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }

            // Print the recognized text
            print(recognizedStrings)
        } catch {
            print(error.localizedDescription)
        }
    }
}

