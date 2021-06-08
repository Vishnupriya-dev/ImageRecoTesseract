//
//  ViewController.swift
//  ImageExtractor
//
//  Created by Mobility on 07/06/21.
//

import UIKit
import MobileCoreServices
import TesseractOCR
import GPUImage

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scannedTxtView: UITextView!
    @IBOutlet weak var synonymTxtView: UITextView!

    lazy var viewModel: ImageViewModel = {
        return ImageViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initVM()
    }

    // MARK: IBActions
    //Method to invoke camera for scanning
    @IBAction func btnCameraTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
        self.activityIndicator.startAnimating()
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
         imagePicker.sourceType = .camera
         imagePicker.mediaTypes = [kUTTypeImage as String]
         self.present(imagePicker, animated: true, completion: {
         self.activityIndicator.stopAnimating()
         })
       // viewModel.getSynonym(word: "Fast")
        }
    }

    //Method to get image from Gallery
    @IBAction func btnGalleryTapped(_ sender: Any) {
        self.activityIndicator.startAnimating()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagePicker, animated: true, completion: {
            self.activityIndicator.stopAnimating()
        })
    }

    // MARK: Private methods
    //Method to initialise ViewModel
    func initVM() {
        viewModel.updateValues = { [weak self] (dictWordInfo) in
            print(dictWordInfo)
            self?.synonymTxtView.text = dictWordInfo
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto =
                info[.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }

        activityIndicator.startAnimating()
        dismiss(animated: true) {
            self.performImageRecognition(selectedPhoto)
        }
    }
    
    // Tesseract Image Recognition
    func performImageRecognition(_ image: UIImage) {
        let scaledImage = image.scaledImage(1000) ?? image
        let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage

        if let tesseract = G8Tesseract(language: "eng+fra") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto

            tesseract.image = preprocessedImage
            tesseract.recognize()
            scannedTxtView.text = tesseract.recognizedText
            if tesseract.recognizedText != nil && tesseract.recognizedText != "" {
                let array = tesseract.recognizedText!.components(separatedBy: CharacterSet.newlines)
                viewModel.getSynonym(word: array.first ?? "")
            }
        }
        activityIndicator.stopAnimating()
    }
}


