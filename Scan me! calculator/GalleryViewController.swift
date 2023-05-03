import UIKit
import Vision

class GalleyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instance of UIImagePickerController
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }

    @IBAction func selectImage(_ sender: UIButton) {
        // Present the UIImagePickerController to the user
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the selected image
        guard let image = info[.originalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }

        // Perform text recognition on the selected image
        recognizeText(image: image)

        // Dismiss the UIImagePickerController
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Text Recognition

    func recognizeText(image: UIImage) {
        // Create a VNImageRequestHandler to process the image
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])

        // Create a VNDetectTextRectanglesRequest to recognize text in the image
        let request = VNRecognizeTextRequest { (request, error) in
            // Handle the recognition results
            // Process the recognized text
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }

            // Print the recognized text
            print(recognizedStrings)
        }

        // Set the recognition level to accurate for higher accuracy
        request.recognitionLevel = .accurate

        // Perform the text recognition request
        do {
            try requestHandler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
}
