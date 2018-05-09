//
//  ViewController.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/08.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detect(image: self.imageView.image!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        picker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(#function)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        var completion:(()->Void)? = nil
        Api.detect(image: image, success: {
            (pis) in dump(pis)
            
            let vc:CheckViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckViewController") as! CheckViewController
            vc.piImage = image
            vc.pis = pis
            self.present(vc, animated: true, completion: nil)
            
            
        }, failure: {
            error in
            completion = {self.showSimpleAlert(title: "Error", message: error.debugDescription, ok_handler: nil, cancel_handler: nil)}
        }, completion: {
            _ in picker.dismiss(animated: true, completion: completion)
        })
    }
    
    func detect(image:UIImage){
        Api.detect(image: image, success: {
            (pis) in dump(pis)
            
            let vc:CheckViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckViewController") as! CheckViewController
            vc.piImage = image
            vc.pis = pis
            self.present(vc, animated: true, completion: nil)
            
        }, failure: {
            error in
            self.showSimpleAlert(title: "Error", message: error.debugDescription, ok_handler: nil, cancel_handler: nil)
        }, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func albumButtonTapped(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}
