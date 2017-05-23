//
//  ViewController.swift
//  PhotoEdit
//
//  Created by 20029981 on 30/03/2017.
//  Copyright © 2017 20029981. All rights reserved.
//

import UIKit;
//import HRToast;
//let themeColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1.0);

class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var viewForScreenShot: UIView!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var gotImage = false;
    
    
    @IBOutlet weak var buttonView: UIStackView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideImageStuff()

        // Do any additional setup after loading the view, typically from a nib.
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func galleryOption(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            print("in gallery option")
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func takePictureOption(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        showImageStuff()
        imageView.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLine(from: lastPoint, to: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            self.drawLine(from: lastPoint, to: lastPoint)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        if(gotImage){
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
            imageView.image?.draw(in: view.bounds)
            let context = UIGraphicsGetCurrentContext()
            context?.move(to: fromPoint)
            context?.addLine(to: toPoint)
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(brushWidth)
            context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            context?.setBlendMode(CGBlendMode.normal)
            context?.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            imageView.alpha = opacity
            UIGraphicsEndImageContext()
        }
    }
    
    @IBAction func saveImage(_ sender: Any) {
        _ = imageView.screenShot;
    
        hideImageStuff()
        
         self.view.makeToast(message: "Picture Saved", duration: 2.0, position:HRToastPositionCenter as AnyObject)

    }
    @IBAction func cancel(_ sender: Any) {
        hideImageStuff()
    }
    
    func hideImageStuff(){
        buttonView.isHidden = false;
        takePictureButton.isEnabled = true;
        galleryButton.isEnabled = true;
        gotImage = false;
        colorButton.isEnabled = false;
        saveButton.isEnabled = false;
        colorButton.alpha = 0;
        saveButton.alpha = 0;
        cancelButton.isEnabled = false;
        cancelButton.alpha = 0;
        imageView.isHidden = true;
        
    }
    func showImageStuff(){
        buttonView.isHidden = true;
        takePictureButton.isEnabled = false;
        galleryButton.isEnabled = false;
        gotImage = true;
        saveButton.isEnabled = true;
        saveButton.alpha = 1;
        colorButton.isEnabled = true;
        colorButton.alpha = 1;
        cancelButton.isEnabled = true;
        cancelButton.alpha = 1;
        imageView.isHidden = false;
    }
    
        

}
extension UIImageView {
    
    var screenShot: UIImageView?  {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0);
        if let _ = UIGraphicsGetCurrentContext() {
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            UIImageWriteToSavedPhotosAlbum((screenshot)!, nil, nil, nil)
        }
        return nil
    }
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
//        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

