//
//  ViewController.swift
//  PhotoEdit
//
//  Created by 20029981 on 30/03/2017.
//  Copyright © 2017 20029981. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func galleryOption(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        swiped = true
//        if let touch = touches.first {
//            let currentPoint = touch.location(in: view)
//            drawLine(from: lastPoint, to: currentPoint)
//            
//            lastPoint = currentPoint
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !swiped {
//            // draw a single point
//            self.drawLine(from: lastPoint, to: lastPoint)
//        }
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        swiped = false
//        if let touch = touches.first {
//            lastPoint = touch.location(in: self.view)
//        }
//    }
//    
//    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
//        
//        imageView.image?.draw(in: view.bounds)
//        
//        let context = UIGraphicsGetCurrentContext()
//        
//        context?.move(to: fromPoint)
//        context?.addLine(to: toPoint)
//        
//        context?.setLineCap(CGLineCap.round)
//        context?.setLineWidth(brushWidth)
//        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
//        context?.setBlendMode(CGBlendMode.normal)
//        context?.strokePath()
//        
//        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
//        imageView.alpha = opacity
//        UIGraphicsEndImageContext()
//    }

    
    


    
    
        

}

