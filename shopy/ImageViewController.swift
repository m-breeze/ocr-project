//
//  ImageViewController.swift
//  shopy
//
//  Created by Marina Khort on 23.09.2021.
//

import UIKit

class ImageViewController: UIViewController {

    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        
        detectBoundingBoxes(for: image)
    }
    
    private func detectBoundingBoxes(for image: UIImage) {
      GoogleCloudOCR().detect(from: image) { ocrResult in
        guard let ocrResult = ocrResult else {
          print("Did not recognize any text in this image")
          return
        }
        self.displayBoundingBoxes(for: ocrResult)
  //        print("Text on picture is \(ocrResult)")
          let strResult = ocrResult.annotations.description
          let arrResult = strResult.components(separatedBy: CharacterSet.whitespacesAndNewlines)
  //        let arrResult = strResult.split(whereSeparator: \.isNewline)
          let indexOfBounds = arrResult.firstIndex(of: "boundingBox:")
          let arrayFinal = arrResult[1..<indexOfBounds!]
          
          print("Array is \(arrayFinal)")
      }
    }
    
    private func displayBoundingBoxes(for ocrResult: OCRResult) {
      for annotation in ocrResult.annotations[1...] {
        let _ = createBoundingBoxPath(along: annotation.boundingBox.vertices)
      }
    }

    private func createBoundingBoxPath(along vertices: [Vertex]) -> UIBezierPath {
      let path = UIBezierPath()
      path.move(to: vertices[0].toCGPoint())
      for vertex in vertices[1...] {
        path.addLine(to: vertex.toCGPoint())
      }
      path.close()
      return path
    }
   

}
