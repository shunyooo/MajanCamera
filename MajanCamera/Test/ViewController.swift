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
    let indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        picker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(#function)
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        showIndicator()
        Api.detect(image: image, success: {
            (pis) in dump(pis)
            
            let vc:CheckViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckViewController") as! CheckViewController
            vc.piImage = image
            vc.pis = pis
            self.present(vc, animated: true, completion: nil)
            
            
        }, failure: {
            error in
            self.showSimpleAlert(title: "Error", message: error.debugDescription, ok_handler: nil, cancel_handler: nil)
        }, completion: {
            _ in
            self.stopIndicator()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func albumButtonTapped(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func showIndicator() {
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.center = self.view.center
        indicator.color = UIColor.gray
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        indicator.startAnimating()
    }
    
    func stopIndicator(){
        indicator.stopAnimating()
    }

}
