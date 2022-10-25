//
//  ImageViewController.swift
//  shopy
//
//  Created by Marina Khort on 23.09.2021.
//

import UIKit
import CropViewController

class ImageViewController: UIViewController, CropViewControllerDelegate {
    
    var userPickedImage: UIImage!
    var readyImage: UIImage!
    var viewController: ViewController!
    @IBOutlet weak var cropedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCropViewController()
    }
    
    func presentCropViewController() {
      readyImage = userPickedImage
      let cropViewController = CropViewController(image: readyImage)
      cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    @objc func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.cropedImage.image = image
    }
    
    @objc func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        viewController.detectTextOnPhoto(for: readyImage)
        viewController.imageView.image = readyImage
//        performSegue(withIdentifier: "backSegue", sender: self)
    
    }
       
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      super.prepare(for: segue, sender: sender)
//      if let mainViewController = segue.destination as? ViewController {
//        mainViewController.imageView = cropedImage
//      }
//    }
    

    
//    var image: UIImage!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let imageView = UIImageView(frame: view.frame)
//        imageView.image = image
//        view.addSubview(imageView)
//
//        detectBoundingBoxes(for: image)
//    }
//
//    private func detectBoundingBoxes(for image: UIImage) {
//      GoogleCloudOCR().detect(from: image) { ocrResult in
//        guard let ocrResult = ocrResult else {
//          print("Did not recognize any text in this image")
//          return
//        }
//        self.displayBoundingBoxes(for: ocrResult)
//  //        print("Text on picture is \(ocrResult)")
//          let strResult = ocrResult.annotations.description
//          let arrResult = strResult.components(separatedBy: CharacterSet.whitespacesAndNewlines)
//  //        let arrResult = strResult.split(whereSeparator: \.isNewline)
//          let indexOfBounds = arrResult.firstIndex(of: "boundingBox:")
//          let arrayFinal = arrResult[1..<indexOfBounds!]
//
//          print("Array is \(arrayFinal)")
//      }
//    }
//
//    private func displayBoundingBoxes(for ocrResult: OCRResult) {
//      for annotation in ocrResult.annotations[1...] {
//        let _ = createBoundingBoxPath(along: annotation.boundingBox.vertices)
//      }
//    }
//
//    private func createBoundingBoxPath(along vertices: [Vertex]) -> UIBezierPath {
//      let path = UIBezierPath()
//      path.move(to: vertices[0].toCGPoint())
//      for vertex in vertices[1...] {
//        path.addLine(to: vertex.toCGPoint())
//      }
//      path.close()
//      return path
//    }
//

}
