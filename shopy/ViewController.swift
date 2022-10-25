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
    private var croppingStyle = CropViewCroppingStyle.default

    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
//        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(sender:)))
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapImageView))
               imageView.addGestureRecognizer(tapRecognizer)
        
        
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        imagePicker.allowsEditing = false
    }
    
    @objc public func addButtonTapped(sender: AnyObject) {
           let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           let cameratAction = UIAlertAction(title: "Make photo", style: .default) { (action) in
               self.croppingStyle = .default
               
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
           }
            let libraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
                self.croppingStyle = .default
                
             self.imagePicker.sourceType = .photoLibrary
             self.imagePicker.allowsEditing = false
             self.imagePicker.delegate = self
             self.present(self.imagePicker, animated: true, completion: nil)
            }
           alertController.addAction(cameratAction)
            alertController.addAction(libraryAction)
           alertController.modalPresentationStyle = .popover
           
           let presentationController = alertController.popoverPresentationController
           presentationController?.barButtonItem = (sender as! UIBarButtonItem)
           present(alertController, animated: true, completion: nil)
       }
    
    @objc public func didTapImageView() {
           // When tapping the image view, restore the image to the previous cropping state
           let cropViewController = CropViewController(croppingStyle: self.croppingStyle, image: self.userPickedImage!)
           cropViewController.delegate = self
           let viewFrame = view.convert(imageView.frame, to: navigationController!.view)
           
           cropViewController.presentAnimatedFrom(self,
                                                  fromImage: self.imageView.image,
                                                  fromView: nil,
                                                  fromFrame: viewFrame,
                                                  angle: 0,
                                                  toImageFrame: CGRect.zero,
                                                  setup: { self.imageView.isHidden = true },
                                                  completion: nil)
       }
       
       public override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           layoutImageView()
       }
    
    public func layoutImageView() {
           guard imageView.image != nil else { return }
           
           let padding: CGFloat = 20.0
           
           var viewFrame = self.view.bounds
           viewFrame.size.width -= (padding * 2.0)
           viewFrame.size.height -= ((padding * 2.0))
           
           var imageFrame = CGRect.zero
           imageFrame.size = imageView.image!.size;
           
           if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
               let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
               imageFrame.size.width *= scale
               imageFrame.size.height *= scale
               imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.2
               imageView.frame = imageFrame
           }
           else {
               self.imageView.frame = imageFrame;
               self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
           }
       }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.originalImage] as? UIImage else {return}
        let cropController = CropViewController(croppingStyle: croppingStyle, image: userPickedImage)
        cropController.delegate = self
        self.userPickedImage = userPickedImage
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
        })
        
        
//        performSegue(withIdentifier: "cropSegue", sender: self)
//        detectTextOnPhoto(for: userPickedImage)
//        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
          updateImageViewWithImage(image, fromCropViewController: cropViewController)
      }
    
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        layoutImageView()
        detectTextOnPhoto(for: image)
        self.imageView.isHidden = false
        cropViewController.dismiss(animated: true, completion: nil)
           
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
        let ocrR = ocrResult.annotations[0].text
        return ocrR
    }

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      super.prepare(for: segue, sender: sender)
//      if let cropViewController = segue.destination as? ImageViewController {
//        cropViewController.userPickedImage = userPickedImage
//      }
//    }

}

