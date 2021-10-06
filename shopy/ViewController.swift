//
//  ViewController.swift
//  shopy
//
//  Created by Marina Khort on 08.09.2021.
//

import UIKit
import CropViewController


class ViewController: UIViewController, UIImagePickerControllerDelegate, UITextViewDelegate,  UINavigationControllerDelegate, CropViewControllerDelegate {

    let imagePicker = UIImagePickerController()
    var userPickedImage: UIImage!
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userPickedImage = info[.originalImage] as? UIImage
        detectTextOnPhoto(for: userPickedImage)
        
//        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func presentCropViewController() {
      let image: UIImage = userPickedImage
      
      let cropViewController = CropViewController(image: image)
      cropViewController.delegate = self
      present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        <#code#>
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detectTextOnPhoto(for image: UIImage) {
        GoogleCloudOCR().detect(from: image) { [self] ocrResult in
            if ocrResult == nil {
              print("Did not recognize any text in this image")
              return
            }
            let res = makeResultString(for: ocrResult!)
            textView.text = res
        }
    }
    
    func makeResultString(for ocrResult: OCRResult) -> String {
        let ocrDescription = ocrResult.annotations.description
        let arrayDescription = ocrDescription.components(separatedBy: " ")
        let indexOfBounds = arrayDescription.firstIndex(of: "boundingBox:")
        let arrayFinal = arrayDescription[1..<indexOfBounds!]
        let resultedString = arrayFinal.joined(separator: " ")
        let replacedString = resultedString.replacingOccurrences(of: "\\n", with: "\n")
        print("string: \(replacedString)")
        return replacedString
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      super.prepare(for: segue, sender: sender)
//      if let imageViewController = segue.destination as? ImageViewController {
//        imageViewController.image = userPickedImage
//      }
//    }

//    ,
//      "imageContext": [
//          "languageHints": ["uk"]
//      ]
}

