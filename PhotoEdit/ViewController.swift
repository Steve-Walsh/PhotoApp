//
//  ViewController.swift
//  PhotoEdit
//
//  Created by 20029981 on 30/03/2017.
//  Copyright © 2017 20029981. All rights reserved.
//

import UIKit;
import Social

//import HRToast;
//let themeColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1.0);

class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var exitOptionsView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    

    var selectedColor: UIColor = UIColor.white

    var viewForScreenShot: UIView!
    var backgroundImage: UIImage!
    
    
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
        exitOptionsView.isHidden = true
        saveView.isHidden = true

        
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
        removeDimImageStuff()
        imageView.image = image;
        backgroundImage = image;
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
        if(exitOptionsView.isHidden == false){
            exitOptionsView.isHidden = true
            removeDimImageStuff()
        }else if (saveView.isHidden == false){
            saveView.isHidden = true
            removeDimImageStuff()
        }else{
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
    }
    
    //save image details
    @IBAction func saveImage(_ sender: Any) {
        saveView.isHidden = false
        exitOptionsView.isHidden = true
        dimImageStuff()
        
    }
    @IBAction func cancelSave(_ sender: Any) {
        saveView.isHidden = true
        removeDimImageStuff()
    }
    
    
    @IBAction func saveImageToPhone(_ sender: Any) {
        _ = imageView.screenShot;
        hideImageStuff()
        saveView.isHidden = true
        self.view.makeToast(message: "Picture Saved", duration: 2.0, position:HRToastPositionCenter as AnyObject)
    }
    @IBAction func facebookSave(_ sender: Any) {
        var image = captureScreen()
        
        
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)){
            //_ = imageView.facebook;
            saveView.isHidden = false
            showImageStuff()
            
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeSheet?.setInitialText("Hello, Facebook!")
            composeSheet?.add(image)
            self.present(composeSheet!, animated: true, completion: nil)
            
            self.view.makeToast(message: "Saved to facebook", duration: 2.0, position:HRToastPositionCenter as AnyObject)
        }else{
            saveView.isHidden = false
            showImageStuff()
            self.view.makeToast(message: "Please log into facebook on your phone", duration: 2.0, position:HRToastPositionCenter as AnyObject)
        }
        
    }
    @IBAction func twitterSave(_ sender: Any) {
        
        var image = captureScreen()
        
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)){
            //_ = imageView.twitter;
            saveView.isHidden = false
            showImageStuff()
            
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeSheet!.setInitialText("Hello, twitter!")
            composeSheet!.add(image)
            self.present(composeSheet!, animated: true, completion: nil)
            
            
            self.view.makeToast(message: "Tweet created", duration: 2.0, position:HRToastPositionCenter as AnyObject)
        }else{
            saveView.isHidden = false
            showImageStuff()
            self.view.makeToast(message: "Please log into twitter on your phone", duration: 2.0, position:HRToastPositionCenter as AnyObject)
        }
        
    }
    
    func captureScreen() -> UIImage? {
       
        saveButton.alpha = 0;
        colorButton.alpha = 0;
        cancelButton.alpha = 0;
        exitOptionsView.isHidden = true
        saveView.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //Cancel view options
    
    @IBAction func cancel(_ sender: Any) {
        exitOptionsView.isHidden = false
        saveView.isHidden = true
        dimImageStuff()
        
    }
    @IBAction func cancelEdit(_ sender: Any) {
        hideImageStuff()
        imageView.image = nil
        exitOptionsView.isHidden = true
        
    }
    
    @IBAction func resetImage(_ sender: Any) {
        imageView.image = backgroundImage;
        exitOptionsView.isHidden = true
        removeDimImageStuff()
    }
    
    @IBAction func cancelExitOptions(_ sender: Any) {
        
     exitOptionsView.isHidden = true

    }
//    @IBAction func exitToMain(_ sender: Any) {
//        hideImageStuff()
//        imageView.image = nil
//        exitOptionsView.isHidden = true
//        
//    }
    
    
    
    
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
    
    func dimImageStuff(){
        saveButton.alpha = 0.3;
        colorButton.alpha = 0.3;
        cancelButton.alpha = 0.3;
        imageView.alpha = 0.3
    }
    
    func removeDimImageStuff(){
        saveButton.alpha = 1;
        colorButton.alpha = 1;
        cancelButton.alpha = 1;
        imageView.alpha = 1
    
    }

    
    @IBAction func changeColor(_ sender: AnyObject) {
        
        print("change color")

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
    /*
    var facebook: UIImageView?  {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0);
        if let _ = UIGraphicsGetCurrentContext() {
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //return screenshot

            //let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            //composeSheet?.setInitialText("Hello, Facebook!")
            //composeSheet?.add(screenshot)
            //present(composeSheet, animated: true, completion: nil)
        }
        return nil
    }
    
    var twitter: UIImageView?  {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0);
        if let _ = UIGraphicsGetCurrentContext() {
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeSheet!.setInitialText("Hello, twitter!")
            composeSheet!.add(screenshot!)
            //present(composeSheet, animated: true, completion: nil)
        }
        return nil
    }
     */
}

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
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

